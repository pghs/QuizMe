class Mention < ActiveRecord::Base
	belongs_to :user
	belongs_to :post

	def self.unanswered
		where(:responded => false)
	end


	def self.check_mentions(current_acct)
		client = current_acct.twitter
		return if client.nil?
		mentions = client.mentions({:count => 200})
		mentions.each do |m|
			Mention.save_mention_data(m)
		end
		true
	end

	def self.save_mention_data(m)
		u = User.find_or_create_by_twi_user_id(m.user.id)
		u.update_attributes(:twi_name => m.user.name,
												:twi_screen_name => m.user.screen_name,
												:twi_profile_img_url => m.user.status.user.profile_image_url)
		mention = Mention.find_or_create_by_twi_tweet_id(m.id.to_s)
		unless mention.text == m.text and 
			mention.twi_in_reply_to_status_id == m.in_reply_to_status_id.to_s and
			mention.user_id == u.id
				mention.update_attributes(:text => m.text,
					:twi_in_reply_to_status_id => m.in_reply_to_status_id.to_s,
					:user_id => u.id)
		end
		mention.link_mention_to_post

	end

	def link_mention_to_post
		if self.twi_in_reply_to_status_id
			p = Post.find_by_provider_post_id(self.twi_in_reply_to_status_id.to_s)
			self.update_attributes(:post_id => p.id) if p
		elsif self.text =~ /bit.ly/
			msg = self.text
			link_pos = msg =~ /bit.ly/
			sp = msg.index(/ /,link_pos)
			sp = -1 if sp.nil?
			bitly_link = msg.slice(link_pos..sp)
			p = nil
			p = Post.find_by_url("http://#{bitly_link}") unless bitly_link.nil?
			self.update_attributes(:post_id => p.id) if p
		else
			msg = self.text
			hashtag = msg =~ /#/
			if hashtag
				sp = msg.index(/ /,hashtag)
				sp = -1 if sp.nil?
				question_id = msg.slice(hashtag+1..sp).to_i
				question_id = nil if question_id==0
				q = nil
				q = Question.find_by_q_id(question_id) unless question_id.nil?
				if q
					p = Post.where(:question_id => q.id).order("created_at ASC").first
					self.update_attributes(:post_id => p.id) if p
				end
			end
		end
	end
end
