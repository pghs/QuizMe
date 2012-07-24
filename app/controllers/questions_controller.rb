class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :ok }
    end
  end

  def import_data_from_qmm
    questions = Question.import_data_from_qmm
    qs = questions
    qs.each do |q|
      real_q = Question.find_by_text(q['question']['question'])
      next unless real_q
      real_q.update_attributes(:qb_lesson_id => q['question']['lesson_id'],
                               :qb_q_id => q['question']['q_id'])

      unless q['question']['posts'].nil? or q['question']['posts'].empty?
        q['question']['posts'].each do |p|
          new_p = Post.create(:account_id => p['post']['account_id'].to_i+100,
                :question_id => real_q.id,
                :to_twi_user_id => p['post']['to_twi_user_id'].to_i,
                :provider => p['post']['provider'],
                :text => p['post']['text'],
                :url => p['post']['url'],
                :link_type => p['post']['link_type'],
                :post_type => p['post']['post_type'],
                :provider_post_id => p['post']['provider_post_id'])
          if p['post']['mentions']
            p['post']['mentions'].each do |m|
              u = User.find_or_create_by_twi_screen_name(m['mention']['user']['twi_screen_name'])
              u.update_attributes(:twi_user_id => m['mention']['user']['twi_user_id'],
                                  :twi_name => m['mention']['user']['twi_name'],
                                  :twi_profile_img_url => m['mention']['user']["profile_img_url"])
              new_m = Mention.create(:user_id => u.id,
                                     :post_id => new_p.id,
                                     :text => m['mention']['text'],
                                     :responded => m['mention']['responded'],
                                     :twi_tweet_id => m['mention']['twi_tweet_id'],
                                     :twi_in_reply_to_status_id => m['mention']['twi_in_reply_to_status_id'])
              rep = Rep.create(:user_id => u.id,
                               :post_id => new_p.id,
                               :correct => m['mention']['correct']) unless m['mention']['correct'].nil?
            end
          end
        end
      end
    end
    render :json => questions
  end
end
