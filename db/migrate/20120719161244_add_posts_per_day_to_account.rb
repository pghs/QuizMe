class AddPostsPerDayToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :posts_per_day, :integer, :default => 1
  end
end
