class AddQbIdsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :qb_lesson_id, :integer
    add_column :questions, :qb_q_id, :integer
  end
end
