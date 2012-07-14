class FeedsController < ApplicationController
  def index

  end

  def show
    @account = Account.find(params[:id])
    @posts = @account.posts.order(:created_at).limit(5).includes(:question => :answers)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

  def more
    render :json => Account.find(params[:id]).posts.order(:created_at).limit(5).includes(:question => :answers).as_json(:include => {:question => {:include => :answers}})
  end
end
