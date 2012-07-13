class FeedsController < ApplicationController
  def index

  end

  def show
    puts params.to_json
    account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end
end
