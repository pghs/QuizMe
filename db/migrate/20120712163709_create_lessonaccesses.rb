class CreateLessonaccesses < ActiveRecord::Migration
  def change
    create_table :lessonaccesses do |t|
      t.integer :account_id
      t.integer :studyegg_id

      t.timestamps
    end
  end
end
