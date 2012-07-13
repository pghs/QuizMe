class AddToTwUserIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :to_twi_user_id, :integer
  end
end
