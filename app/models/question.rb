class Question < ActiveRecord::Base
	has_many :posts
  belongs_to :topic

  def create_tweet
      return nil if self.text =~ /Which of the following/ or self.text =~ /image/ or self.text =~ /picture/
      return "#{self.text}" if "#{self.text}".length + 14 < 141
      nil
  end

  def self.post_new_question(current_acct)
    puts 'Finding tweet'
    recent_question_ids = current_acct.posts.where("question_id is not null and provider = 'twitter'").order('created_at DESC').limit(100).collect(&:question_id)
    recent_question_ids = recent_question_ids.empty? ? [0] : recent_question_ids
    puts recent_question_ids
    questions = current_acct.questions.where("topic_id in (?) and id not in (?)", current_acct.topics.collect(&:id) recent_question_ids)

    q = questions.sample
    i = 0
    puts "q.id #{q.id}"
    while q.create_tweet.nil?
      q = questions.sample
      i+=1
      raise 'COULD NOT FIND NEW QUESTION TO TWEET' if i>100
    end
    puts 'FOUND!'
    
    ##Post to quizme and twitter
    Post.quizme(current_acct, q.text, q.id)
    Post.tweet(current_acct, q.text, q.url, 'initial', q.id) if current_acct.twi_oauth_token
  end

  def self.post_question(current_acct, queue_index, shift)
    pq = PostQueue.find_by_account_id_and_index(current_acct.id, queue_index)
    return unless pq
    q_id = pq.question_id
    q = Question.find(q_id)
    puts "TWEET: #{q.question}"
    Post.tweet(current_acct, q.question, q.url, "initial#{shift}", q.id) if current_acct.twi_oauth_token
    puts "TUMBLR: #{q.question}"
    Post.create_tumblr_post(current_acct, q.question, q.url, "initial#{shift}", q.id) if current_acct.tum_oauth_token
  end


  ###THIS IS FOR IMPORTING FROM QUESTION BASE###
	require 'net/http'
  require 'uri'

  @qb = Rails.env.production? ? 'http://questionbase.studyegg.com' : 'http://localhost:3001'

  def self.get_studyegg_details(egg_id)
    url = URI.parse("#{@qb}/api-V1/JKD673890RTSDFG45FGHJSUY/get_book_details/#{egg_id}.json")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    begin
      studyegg = JSON.parse(res.body)
    rescue
      studyegg=nil
    end
    return studyegg
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

  def self.import_studyegg_from_qb(egg_id, topic_name)
    egg = Question.get_studyegg_details(egg_id)
    egg['chapters'].each do |ch|
      Question.save_lesson(ch, topic_name)
    end
  end

  def self.import_lesson_from_qb(lesson_id, topic_name)
    lesson = Question.get_lesson_details(lesson_id.to_s)
    lesson.each do |l|
      Question.save_lesson(l, topic_name)
    end
  end

  def self.save_lesson(lesson, topic_name)
    @lesson_id = lesson['id'].to_i
    puts @lesson_id
    if @lesson_id
      questions = Question.get_lesson_questions(@lesson_id)
      return if questions['questions'].nil?
      topic = Topic.find_or_create_by_name(topic_name)
      questions['questions'].each do |q|
        new_q = Question.create(:text => Question.clean_and_clip_question(q['question']),
                                :topic_id => topic.id)
        q['answers'].each do |a|
          Answer.create(:text => Question.clean_text(a['answer']),
                        :correct => a['correct'],
                        :question_id => new_q.id)
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
