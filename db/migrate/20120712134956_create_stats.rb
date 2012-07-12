class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.datetime :date
      t.integer :followers
      t.integer :followers_delta
      t.integer :friends
      t.integer :friends_delta
      t.integer :tweets
      t.integer :tweets_delta
      t.integer :rts
      t.integer :rts_today
      t.integer :mentions
      t.integer :mentions_today
      t.integer :questions_answered
      t.integer :questions_answered_today, :default => 0
      t.integer :unique_active_users
      t.integer :three_day_inactive_users
      t.integer :one_week_inactive_users
      t.integer :one_month_plus_inactive_users

      t.timestamps
    end
  end
end
