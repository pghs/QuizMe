class User < ActiveRecord::Base
	has_many :mentions
	has_many :reps

	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth["provider"]
	    user.twi_user_id = auth["uid"]
	    user.twi_screen_name = auth["info"]["nickname"]
	    user.twi_name = auth["info"]["name"]
	    user.twi_profile_img_url = auth["extra"]["raw_info"]["profile_image_url"]
	    user.twi_oauth_token = auth['credentials']['token']
			user.twi_oauth_secret = auth['credentials']['secret']
	  end
	end

	def twitter
		if self.twi_oauth_token and self.twi_oauth_secret
			client = Twitter::Client.new(:consumer_key => SERVICES['twitter']['key'],
																 :consumer_secret => SERVICES['twitter']['secret'],
																 :oauth_token => self.twi_oauth_token,
																 :oauth_token_secret => self.twi_oauth_secret)
		end
		client
	end

	def self.get_followers(current_acct)
		client = current_acct.twitter
		follower_ids = client.follower_ids.ids
		count = 0
		follower_ids.each do |id|
			user = User.find_by_twi_user_id(id)
			next if user or count>25
			User.create_user_from_follower(current_acct, id) 
			count += 1
		end
	end

	def self.create_user_from_follower(current_acct, id)
		client = current_acct.twitter
		user = client.user(id)
		u = User.find_or_create_by_twi_user_id(user.id)
		u.update_attributes(:twi_name => user.name,
												:twi_screen_name => user.screen_name,
												:twi_profile_img_url => user.status.user.profile_image_url)
	end

end
