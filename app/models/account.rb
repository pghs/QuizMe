class Account < ActiveRecord::Base
	has_many :posts
	has_many :topics, :through => :accountstopics
	has_many :accountstopics

	def twitter
		if self.twi_oauth_token and self.twi_oauth_secret
			client = Twitter::Client.new(:consumer_key => SERVICES['twitter']['key'],
																 :consumer_secret => SERVICES['twitter']['secret'],
																 :oauth_token => self.twi_oauth_token,
																 :oauth_token_secret => self.twi_oauth_secret)
		end
		client
	end

	def tumblr
		if self.tum_oauth_token and self.tum_oauth_secret
			client = Tumblife::Client.new(:consumer_key => SERVICES['tumblr']['key'],
																 :consumer_secret => SERVICES['tumblr']['secret'],
																 :oauth_token => self.tum_oauth_token,
																 :oauth_token_secret => self.tum_oauth_secret)
		end
		client
	end

	def unanswered
		count = 0
		self.posts.each do |p|
			count += p.mentions.unanswered.count
		end
		count
	end

	def self.get_top_scorers(id, data = {}, scores = [])
		account = Account.select([:name, :id]).find(id)
		posts = Post.where(:account_id => account.id).select(:id).collect(&:id)
		mentions = Mention.where(:post_id => posts, :correct => true).select([:user_id, :id]).group_by(&:user_id).to_a.sort! {|a, b| b[1].length <=> a[1].length}[0..9]
		user_ids = mentions.collect { |mention| mention[1][0][:user_id] }
		users = User.select([:twi_screen_name, :id]).find(user_ids).group_by(&:id)
		mentions.each { |mention| scores << {:handle => users[mention[0]][0].twi_screen_name, :correct => mention[1].length} }
		data[:name] = account.name
		data[:scores] = scores
		return data
	end	
end
