#lib/tasks/cron.rake
task :check_qb_for_questions => :environment do
	Question.import_all_public_from_qb
end

task :check_mentions => :environment do
	accounts = Account.where('twi_oauth_token is not null')
	accounts.each do |a|
		Mention.check_mentions(a)
		sleep(10)
	end
end

task :tweet => :environment do
	t = Time.now
	accounts = Account.all
	accounts.each do |a|
		shift = (t.hour/a.posts_per_day.to_f).floor + 1
		queue_index = t.hour%a.posts_per_day
		Question.post_question(a, queue_index, shift)
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

task :dm_new_followers => :environment do
	account = Account.first
	Post.dm_new_followers(account)
	sleep(10)
end