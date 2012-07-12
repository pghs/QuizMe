class MentionsController < ApplicationController
  def update
  	m = Mention.find(params[:mention_id])
  	if m
	  	m.update_attributes(:correct => params[:correct],
	  											:responded => true)
	  	stat = Stat.find_or_create_by_date(Date.today)
	  	stat.
	  	render :nothing => true, :status => 200
	  else
	  	render :nothing => true, :status => 500
	  end
  end

end
