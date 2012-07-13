class CreateReps < ActiveRecord::Migration
  def change
    create_table :reps do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :correct

      t.timestamps
    end
  end
end
