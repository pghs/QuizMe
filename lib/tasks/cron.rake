#lib/tasks/cron.rake
task :check_qb_for_questions => :environment do
	Question.import_from_qb
end

task :check_mentions => :environment do
	accounts = Account.where(:twi_oauth_token not nil)
	accounts.each do |a|
		Mention.check_mentions(a)
		sleep(10)
	end
end

task :tweet => :environment do
	accounts = Account.where(:id => 1)#where(:twi_oauth_token not nil)
	accounts.each do |a|
		Question.tweet_next_question(a)
		sleep(10)
	end
end

task :save_stats => :environment do
	d = Date.today
	id = Question.where("updated_at > ? and tweet_id > 0", Time.now-1.days).first.tweet_id
	yesterday_stats = Stat.last

	rts_today = Stat.retweet_count(id)
	rts = rts_today + yesterday_stats.rts
	followers = Stat.follower_count
	followers_delta = followers - yesterday_stats.followers
	friends = Stat.friend_count
	mentions_today = Stat.mention_count(id)
	mentions = mentions_today + yesterday_stats.mentions

end