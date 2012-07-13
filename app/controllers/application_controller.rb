class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :set_account_session
  helper_method :current_acct, :current_user

  # def set_account_session
  # 	session[:account_id] = params[:account_id]
  # end

	private

	def current_acct
	  @current_acct ||= Account.find(session[:account_id]) if session[:account_id]
	end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
