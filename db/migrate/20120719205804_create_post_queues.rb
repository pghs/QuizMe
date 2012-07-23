class CreatePostQueues < ActiveRecord::Migration
  def change
    create_table :post_queues do |t|
      t.integer :account_id
      t.integer :index
      t.integer :question_id

      t.timestamps
    end
  end
end
