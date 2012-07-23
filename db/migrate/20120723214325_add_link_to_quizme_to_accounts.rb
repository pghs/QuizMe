class AddLinkToQuizmeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :link_to_quizme, :boolean, :default => false
  end
end
