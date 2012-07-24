class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :destroy_account_session
  helper_method :current_acct, :current_user
  before_filter :referrer_data

  def destroy_account_session
  	session[:account_id] = nil
  end

	private

	def current_acct
	  @current_acct ||= Account.find(session[:account_id]) if session[:account_id]
	end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def referrer_data
    @campaign = params[:c]
    @source = params[:s]
    @link_type = params[:lt]
  end
end
