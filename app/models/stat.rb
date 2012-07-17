class Stat < ActiveRecord::Base
	def self.collect_daily_stats_for(current_acct)
		d = Date.today
		last_post_id = current_acct.posts.where("updated_at > ? and provider = 'twitter' ", Time.now-1.days).first.provider_post_id.to_i
		today = Stat.find_or_create_by_date_and_account_id((d - 1.days).to_s, current_acct.id)
		client = current_acct.twitter
		yesterday = Stat.get_yesterday(current_acct.id)
		twi_account = client.user
		
		followers = twi_account.follower_count
		followers_delta = followers - yesterday.followers
		friends = twi_account.friend_count
		friends_delta = friends - yesterday.friends
		tweets = twi_account.tweet_count
		tweets_delta = tweets - yesterday.tweets
		rts_today = client.retweets_of_me({:count => 200, :since_id => last_post_id}).count
		rts = rts_today + yesterday.rts
		mentions_today = client.mentions({:count => 200, :since_id => last_post_id}).count
		mentions = mentions_today + yesterday.mentions
		today.questions_answered_today = 0
		questions_answered = today.questions_answered_today + yesterday.questions_answered
		
		active = Mention.where("created_at > ? and correct != null", d - 1.days).group(:user_id).count.map{|k,v| k}.to_set
		three_day = Mention.where("created_at > ? and correct != null", d - 8.days).group(:user_id).count.map{|k,v| k}.to_set
		one_week = Mention.where("created_at > ? and correct != null", d - 30.days).group(:user_id).count.map{|k,v| k}.to_set
		one_month = Mention.where("correct != null").group(:user_id).count.map{|k,v| k}.to_set
		unique_active_users = active.count
		three_day_inactive_users = (three_day - active).count
		one_week_inactive_users = (one_week - three_day - active).count
		one_month_plus_inactive_users = (one_month - one_week - three_day - active).count

		today.update_attributes(:followers => followers,
														:followers_delta => followers_delta,
														:friends => friends,
														:friends_delta => friends_delta,
														:tweets => tweets,
														:tweets_delta => tweets_delta,
														:rts => rts,
														:rts_today => rts_today,
														:mentions => mentions,
														:mentions_today => mentions_today,
														:questions_answered => questions_answered,
														:unique_active_users => unique_active_users,
														:three_day_inactive_users => three_day_inactive_users,
														:one_week_inactive_users => one_week_inactive_users,
														:one_month_plus_inactive_users => one_month_plus_inactive_users)
	end

	def self.get_yesterday(id)
		###get yesterdays stats or create dummy yesterday for math
		d = Date.today
		num_days_back = 2
		yesterday = Stat.find_by_date_and_account_id((d - num_days_back.days).to_s, id)
		while yesterday.nil? and num_days_back <= 8
			num_days_back += 1
			yesterday = Stat.find_by_date_and_account_id((d - num_days_back.days).to_s, id)
		end
		if yesterday.nil?
			yesterday = Stat.new
			yesterday.followers = 0
      yesterday.followers_delta = 0
      yesterday.friends = 0
      yesterday.friends_delta = 0
      yesterday.tweets = 0
      yesterday.tweets_delta = 0
      yesterday.rts = 0
      yesterday.rts_today = 0
      yesterday.mentions = 0
      yesterday.mentions_today = 0
      yesterday.questions_answered = 0
      yesterday.questions_answered_today = 0
      yesterday.unique_active_users = 0
      yesterday.three_day_inactive_users = 0
      yesterday.one_week_inactive_users = 0
      yesterday.one_month_plus_inactive_users = 0
		end
		yesterday
	end
end
