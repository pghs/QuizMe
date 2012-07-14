#lib/tasks/cron.rake
require 'pusher'

task :check_mentions => :environment do
	accounts = Account.where('twi_oauth_token is not null')
	accounts.each do |a|
		Mention.check_mentions(a)
		sleep(10)
	end
end

task :post_next => :environment do
	t = Time.now
	accounts = Account.all
	accounts.each do |a|
		# if t.hour%3==0
		# 	p = a.posts.last
		# 	p.repost_tweet('Review: ')
		# else
			# Question.post_next_question(a)
		# end
		Question.post_new_question(a)
		sleep(10)
	end

	account = Account.first
	Pusher.app_id = '23912'
	Pusher.key = 'bffe5352760b25f9b8bd'
	Pusher.secret = '782e6b3a20d17f5896dc'
	Pusher[account.name].trigger('new_post', account.posts.first.question.as_json(:include => :answers))
end

task :save_stats => :environment do
	accounts = Account.where('twi_oauth_token is not null')
	accounts.each do |a|
		Stat.collect_daily_stats_for(a)
		sleep(10)
	end
end

task :check_followers => :environment do
	puts "check followers"	
end