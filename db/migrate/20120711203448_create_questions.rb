class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.string :url
      t.integer :topic_id

      t.timestamps
    end
  end
end
