class FeedsController < ApplicationController
  def index

  end

  def show
    account = Account.find(params[:id], :include => :posts)
    @posts = account.posts.limit(5)

    @posts.each do |post|
      puts post.question.to_json
    end
    # puts @posts.to_json
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end
end
