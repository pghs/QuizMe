class User < ActiveRecord::Base
	has_many :mentions

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
