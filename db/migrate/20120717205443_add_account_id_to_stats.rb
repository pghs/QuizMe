class AddAccountIdToStats < ActiveRecord::Migration
  def change
    add_column :stats, :account_id, :integer
  end
end
