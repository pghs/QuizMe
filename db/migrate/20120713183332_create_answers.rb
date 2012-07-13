class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean :correct
      t.integer :question_id
      t.text :text

      t.timestamps
    end
  end
end
