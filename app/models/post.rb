class Post < ActiveRecord::Base
	belongs_to :question
	belongs_to :account
	has_many :mentions

	def repost_tweet(prefix='')
		authorize = UrlShortener::Authorize.new 'o_29ddlvmooi', 'R_4ec3c67bda1c95912185bc701667d197'
    shortener = UrlShortener::Client.new authorize
    begin
      url = shortener.shorten("#{self.question.url}?s=twi&lt=repost&c=#{current_acct.twi_screen_name}").urls
      account = Account.find(self.account_id)
      res = account.twitter.update("#{prefix}#{self.text} #{url}")
      puts res.inspect
      Post.create(:account_id => current_acct.id,
                  :question_id => self.question.id,
                  :provider => 'twitter',
                  :text => "#{prefix}#{self.text}",
                  :url => url,
                  :link_type => 'repost',
                  :post_type => 'status',
                  :provider_post_id => res.id.to_s)
    rescue e
      puts "error reposting tweet: #{e}"
    end
	end

	# def self.get_old_tweets(current_acct)
	# 	client = current_acct.twitter
	# 	posts = client.user_timeline(current_acct.twi_screen_name, {:count => 100, :exclude_replies => true})
	# 	posts.each do |p|
	# 		q = nil
	# 		msg = p.text
	# 		hashtag = msg =~ /#/
	# 		if hashtag
	# 			sp = msg.index(/ /,hashtag)
	# 			sp = -1 if sp.nil?
	# 			question_id = msg.slice(hashtag+1..sp).to_i
	# 			question_id = nil if question_id==0
	# 			q = Question.find_by_q_id(question_id) unless question_id.nil?
	# 		end

	# 		if q
	# 			post = Post.find_or_create_by_provider_post_id(p.id.to_s)
	# 			puts p.id
	# 			post.update_attributes(:account_id => current_acct.id,
	# 													 :provider => 'twitter',
	# 													 :text => p.text,
	# 													 :post_type => 'status',
	# 													 :question_id => q.id)
	# 		end
	# 	end
	# end
end
