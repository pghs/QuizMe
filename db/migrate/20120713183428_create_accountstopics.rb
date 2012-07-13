class CreateAccountstopics < ActiveRecord::Migration
  def change
    create_table :accountstopics do |t|
      t.integer :account_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
