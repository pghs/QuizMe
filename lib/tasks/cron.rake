#lib/tasks/cron.rake

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
			Question.post_next_question(a)
		# end
		sleep(10)
	end
end

task :fill_queue => :environment do
	PostQueue.clear_queue
	accounts = Account.all
	accounts.each do |a|
		Question.select_questions_to_post(a, 7)
	end
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