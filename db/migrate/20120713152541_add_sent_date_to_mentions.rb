class AddSentDateToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :sent_date, :datetime
  end
end
