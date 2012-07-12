# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120712163709) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "twi_name"
    t.string   "twi_screen_name"
    t.integer  "twi_user_id"
    t.text     "twi_profile_img_url"
    t.string   "twi_oauth_token"
    t.string   "twi_oauth_secret"
    t.string   "fb_oauth_token"
    t.string   "fb_oauth_secret"
    t.string   "tum_oauth_token"
    t.string   "tum_oauth_secret"
    t.string   "tum_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessonaccesses", :force => true do |t|
    t.integer  "account_id"
    t.integer  "studyegg_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "text"
    t.boolean  "responded"
    t.boolean  "first_answer"
    t.boolean  "correct"
    t.string   "twi_tweet_id"
    t.string   "twi_in_reply_to_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "account_id"
    t.integer  "question_id"
    t.string   "provider"
    t.text     "text"
    t.string   "url"
    t.string   "link_type"
    t.string   "post_type"
    t.string   "provider_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "q_id"
    t.integer  "lesson_id"
    t.integer  "studyegg_id"
    t.text     "question"
    t.text     "answer"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", :force => true do |t|
    t.datetime "date"
    t.integer  "followers"
    t.integer  "followers_delta"
    t.integer  "friends"
    t.integer  "friends_delta"
    t.integer  "tweets"
    t.integer  "tweets_delta"
    t.integer  "rts"
    t.integer  "rts_today"
    t.integer  "mentions"
    t.integer  "mentions_today"
    t.integer  "questions_answered"
    t.integer  "questions_answered_today"
    t.integer  "unique_active_users"
    t.integer  "three_day_inactive_users"
    t.integer  "one_week_inactive_users"
    t.integer  "one_month_plus_inactive_users"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "twi_name"
    t.string   "twi_screen_name"
    t.integer  "twi_user_id"
    t.text     "twi_profile_img_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
