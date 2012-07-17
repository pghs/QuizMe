class AccountsController < ApplicationController

  def index
    session[:account_id] = nil
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
    session[:account_id] = params[:id]
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
    @studyegg_ids = Question.group(:studyegg_id).count.map{|k,v| k}
    puts @studyegg_ids
    session[:account_id] = params[:id]
  end

  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_omniauth
    return if current_acct.nil?
    auth = request.env['omniauth.auth']
    provider = auth['provider']

    case provider
    when 'twitter'
      current_acct.update_attributes(:twi_oauth_token => auth['credentials']['token'],
                                    :twi_oauth_secret => auth['credentials']['secret'],
                                    :twi_name => auth['info']['name'],
                                    :twi_screen_name => auth['info']['nickname'],
                                    :twi_user_id => auth['uid'].to_i,
                                    :twi_profile_img_url => auth['info']['image'])
    when 'tumblr'
      current_acct.update_attributes(:tum_oauth_token => auth['credentials']['token'],
                                    :tum_oauth_secret => auth['credentials']['secret'])
    when 'facebook'
      current_acct.update_attributes(:fb_oauth_token => auth['credentials']['token'],
                                    :fb_oauth_secret => auth['credentials']['secret'])
    else
      puts "provider unknown: #{provider}"
    end
    redirect_to "/accounts/#{current_acct.id}"
  end

  def update
  	@account = Account.find(params[:id])

    if @account.update_attributes(params[:account])
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render action: "edit"
    end
  end


  def destroy
    @account = Account.find(params[:id])
    @account.destroy

		redirect_to accounts_url
  end

  def followers
    @account = Account.find(params[:id
    @new_followers = @account.twitter.follower_ids.ids.first 10
    @messaged = Post.where(:account_id => params[:id],
                            :provider => 'twitter',
                            :post_type => 'dm').collect(&:to_twi_user_id)

  end
end
