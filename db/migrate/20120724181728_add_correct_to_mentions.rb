class AddCorrectToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :correct, :boolean
  end
end
