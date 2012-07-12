class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_acct

	private

	def current_acct
	  @current_acct ||= Account.find(session[:account_id]) if session[:account_id]
	end
end
