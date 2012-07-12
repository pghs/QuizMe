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
	t = Time.now
	accounts = Account.where(:id => 1)#where(:twi_oauth_token not nil)
	accounts.each do |a|
		if t.hour%3==0
			p = a.posts.last
			p.repost_tweet('Review: ')
		else
			Question.tweet_next_question(a)
		end
		sleep(10)
	end
end

task :save_stats => :environment do
	accounts = Account.where(:twi_oauth_token not nil)
	accounts.each do |a|
		Stat.collect_daily_stats_for(a)
		sleep(10)
	end
end