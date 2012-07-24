class FeedsController < ApplicationController
  def index

  end

  def show
    @account = Account.find(params[:id])
    @posts = @account.posts.where(:provider => "quizme").order("created_at DESC").limit(15).includes(:question => :answers)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

  def more
    post = Post.find(params[:last_post_id])
    render :json => Account.find(params[:id]).posts.where("CREATED_AT > ? AND ID IS NOT ?", post.created_at, post.id).order(:created_at).limit(5).includes(:question => :answers).as_json(:include => {:question => {:include => :answers}})
  end

  def scores
    @scores = Account.get_top_scorers(params[:id])
  end
end
