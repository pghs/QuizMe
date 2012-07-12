class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :q_id
      t.integer :lesson_id
      t.integer :studyegg_id
      t.text :question
      t.text :answer
      t.string :url

      t.timestamps
    end
  end
end
