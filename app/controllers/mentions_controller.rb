class MentionsController < ApplicationController

	def index
		@orphans = Mention.where('post_id is null')
		@posts = current_acct.posts.where('question_id is not null and provider = "twitter"').order('created_at DESC').limit(25)
	end

  def update
  	m = Mention.find(params[:mention_id])
  	correct = params[:correct]=='null' ? nil : params[:correct].match(/(true|t|yes|y|1)$/i) != nil

  	puts m.inspect
  	if m
	  	m.update_attributes(:correct => correct,
	  											:responded => true)

	  	case correct
	  	when true
		  	stat = Stat.find_or_create_by_date(Date.today.to_s)
		  	stat.increment(:questions_answered_today)
		  	m.respond_correct
	  	when false
	  		stat = Stat.find_or_create_by_date(Date.today.to_s)
		  	stat.increment(:questions_answered_today)
		  	m.respond_incorrect
	  	when nil
	  		puts 'skipped'
	  	else
	  		puts 'an error has occurred:: MentionsController :: LINE 24'
	  	end
	  	#render :nothing => true, :status => 200
	  else
	  	puts 'else'
	  	#render :nothing => true, :status => 500
	  end
  end

end
