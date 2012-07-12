class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :text
      t.boolean :responded, :default => false
      t.boolean :first_answer, :default => false
      t.boolean :correct
      t.string :twi_tweet_id
      t.string :twi_in_reply_to_status_id

      t.timestamps
    end
  end
end
