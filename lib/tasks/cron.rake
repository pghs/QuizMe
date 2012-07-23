#lib/tasks/cron.rake
require 'pusher'
Pusher.app_id = '23912'
Pusher.key = 'bffe5352760b25f9b8bd'
Pusher.secret = '782e6b3a20d17f5896dc'

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
		post = Question.post_new_question(a)
		# Pusher[a.name].trigger('new_post', post.as_json(:include => {:question => {:include => :answers}}))
		# sleep(10)
	end

	# NOTE: the push should contain the new post to be added to each feed. We
	# could have a separate channel for each feed. Alternatively, all feeds
	# listen to the same channel, ALL new posts would get pushed to all feeds
	# where they would sort them out.
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