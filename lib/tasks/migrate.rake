task :update_mentions_with_sent_date => :environment do
	mentions = Mention.all
	mentions.each do |m|
		if m.sent_date.nil?
			next if m.post.nil? or m.post.empty?
			puts m.id
			a = Account.find(m.post.account_id)
			t = a.twitter.status(m.twi_tweet_id.to_i)
			sent_date = t.created_at
			m.update_attributes(:sent_date => sent_date)
		end
	end
end