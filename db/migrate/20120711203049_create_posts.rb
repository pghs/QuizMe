class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :account_id
      t.integer :question_id
      t.string :provider
      t.text :text
      t.string :url
      t.string :link_type
      t.string :post_type
      t.string :provider_post_id

      t.timestamps
    end
  end
end
