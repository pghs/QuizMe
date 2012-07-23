class Post < ActiveRecord::Base
	belongs_to :question
	belongs_to :account
	has_many :mentions
	has_many :reps

	def repost_tweet
		account = Account.find(self.account_id)
		Post.tweet(account, self.text, self.question.url, "repost", self.question_id)
	end

	def self.shorten_url(url, source, lt, campaign, question_id)
		authorize = UrlShortener::Authorize.new 'o_29ddlvmooi', 'R_4ec3c67bda1c95912185bc701667d197'
    shortener = UrlShortener::Client.new authorize
    url = shortener.shorten("#{url}?s=#{source}&lt=#{lt}&c=#{campaign}#question_#{question_id}").urls
    url
	end

	def self.tweet(current_acct, tweet, url, lt, question_id)
		short_url = Post.shorten_url(url, 'twi', lt, current_acct.twi_screen_name, question_id)
    res = current_acct.twitter.update("#{tweet} #{short_url}")
    Post.create(:account_id => current_acct.id,
                :question_id => question_id,
                :provider => 'twitter',
                :text => tweet,
                :url => short_url,
                :link_type => lt,
                :post_type => 'status',
                :provider_post_id => res.id.to_s)
  end

  def self.dm(current_acct, tweet, url, lt, question_id, user_id)
  	short_url = Post.shorten_url(url, 'twi', lt, current_acct.twi_screen_name) if url
    res = current_acct.twitter.direct_message_create(user_id, "#{tweet} #{short_url if short_url}")
    Post.create(:account_id => current_acct.id,
                :question_id => question_id,
                :to_twi_user_id => user_id,
                :provider => 'twitter',
                :text => tweet,
                :url => url.nil? ? nil : short_url,
                :link_type => lt,
                :post_type => 'dm',
                :provider_post_id => res.id.to_s)
  end
  
  def self.quizme(current_acct, question, question_id)
  	Post.create(:account_id => current_acct.id,
                :question_id => question_id,
                :provider => 'quizme',
                :text => question,
                :post_type => 'question')
  end
end
