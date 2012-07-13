class FeedsController < ApplicationController
  def index

  end

  def show
    @account = Account.find(params[:id])
    @posts = @account.posts.limit(5).includes(:question => :answers)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end
end
