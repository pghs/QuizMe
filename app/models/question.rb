class Question < ActiveRecord::Base
	has_many :posts
  has_many :lessonaccesses

  BIO = [13]

  def create_tweet
      return nil if self.question =~ /Which of the following/ or self.question =~ /image/ or self.question =~ /picture/
      return "#{self.question} ##{self.q_id}" if "#{self.question} ##{self.q_id}".length + 14 < 141
      nil
  end

  def post_new_to_twitter(current_acct)
    authorize = UrlShortener::Authorize.new 'o_29ddlvmooi', 'R_4ec3c67bda1c95912185bc701667d197'
    shortener = UrlShortener::Client.new authorize
    tweet = self.create_tweet
    puts tweet
    if tweet
      url = shortener.shorten("#{self.url}?s=twi&lt=initial&c=#{current_acct.twi_screen_name}").urls
      res = current_acct.twitter.update("#{tweet} #{url}")
      puts res.inspect
      Post.create(:account_id => current_acct.id,
                  :question_id => self.id,
                  :provider => 'twitter',
                  :text => tweet,
                  :url => url,
                  :link_type => 'initial',
                  :post_type => 'status',
                  :provider_post_id => res.id.to_s)
    end
  end

  def self.tweet_next_question(current_acct)
    puts 'Finding tweet'
    recent_question_ids = current_acct.posts.where("question_id is not null").order('created_at DESC').limit(100).collect(&:question_id)
    recent_question_ids = recent_question_ids.empty? ? [0] : recent_question_ids
    puts recent_question_ids
    access = Lessonaccess.where(:account_id => current_acct.id).collect(&:studyegg_id)
    access = access.empty? ? [0] : access
    puts "access"
    puts access
    questions = Question.where("studyegg_id in (?) and id not in (?)", access, recent_question_ids)

    q = questions.sample
    i = 0
    puts "q_id #{q.id}"
    while q.create_tweet.nil?
      q = questions.sample
      i+=1
      raise 'COULD NOT FIND NEW QUESTION TO TWEET' if i>100
    end
    puts 'FOUND!'
    puts q.inspect
    q.post_new_to_twitter(current_acct)
  end



  ###THIS IS FOR IMPORTING FROM QUESTION BASE###
	require 'net/http'
  require 'uri'

  @qb = Rails.env.production? ? 'http://questionbase.studyegg.com' : 'http://localhost:3001'

  def self.get_public_with_lessons
    url = URI.parse("#{@qb}/api-V1/JKD673890RTSDFG45FGHJSUY/get_public_with_lessons.json")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    begin
      studyeggs = JSON.parse(res.body)
    rescue
      studyeggs=[]
    end
    return studyeggs
  end
  
  def self.get_lesson_questions(lesson_id)
    url = URI.parse("#{@qb}/api-V1/JKD673890RTSDFG45FGHJSUY/get_all_lesson_questions/#{lesson_id}.json")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    begin
      studyegg = JSON.parse(res.body)
    rescue
      studyegg = nil
    end
    return studyegg
  end

  def self.get_lesson_details(lesson)
    url = URI.parse("#{@qb}/api-V1/JKD673890RTSDFG45FGHJSUY/get_lesson_details/#{lesson}")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    begin
      studyeggs = JSON.parse(res.body)
    rescue
      studyeggs = []
    end
    return studyeggs
  end

  def self.get_studyegg_id_by_lesson_id(lesson_id)
    url = URI.parse("#{@qb}/api-V1/JKD673890RTSDFG45FGHJSUY/get_book_id_by_chapter_id/#{lesson_id}.json")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    begin
      studyegg = res.body
    rescue
      studyegg=nil
    end
    return studyegg
  end

  def self.import_all_public_from_qb
    public_eggs = Question.get_public_with_lessons
    public_eggs.each do |p|
      p['chapters'].each do |ch|
        Question.save_lesson(ch, p['id'])
      end
    end
  end

  def self.import_lesson_from_qb(lesson_id)
    lesson = Question.get_lesson_details(lesson_id.to_s)
    egg_id = get_studyegg_id_by_lesson_id(lesson_id)
    puts egg_id
    lesson.each do |l|
      Question.save_lesson(l, egg_id)
    end
  end

  def self.save_lesson(ch, egg_id)
    @lesson_id = ch['id'].to_i
    puts @lesson_id
    if @lesson_id
      questions = Question.get_lesson_questions(@lesson_id)
      return if questions['questions'].nil?
      questions['questions'].each do |q|
        @q_id = q['id'].to_i
        @question = q['question']
        @answer = ''
        q['answers'].each do |a|
          @answer = a['answer'] if a['correct']
        end
        new_q = Question.find_by_q_id(@q_id)
        unless new_q
          Question.create(:q_id => @q_id, 
                          :lesson_id => @lesson_id, 
                          :studyegg_id => egg_id,
                          :question => Question.clean_and_clip_question(@question),
                          :answer => Question.clean_text(@answer),
                          :url => "http://www.studyegg.com/review/#{@lesson_id}/#{@q_id}")
        end
      end
    end
  end

  def self.clean_and_clip_question(quest)
    if quest[0..3].downcase=='true'
      i = quest.downcase.index('false')
      quest = "T\\F: "+ quest[(i+7)..-1]
    end
    clean_text(quest)
  end

  def self.clean_text(a)
    a.gsub!('<sub>','')
    a.gsub!('</sub>','')
    a.gsub!('<sup>-</sup>','-')
    a.gsub!('<sup>+</sup>','+')
    a.gsub!('<sup>','^')
    a.gsub!('</sup>','')
    a
  end
end
