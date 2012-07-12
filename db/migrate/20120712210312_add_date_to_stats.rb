class AddDateToStats < ActiveRecord::Migration
  def change
  	remove_column :stats, :date
    add_column :stats, :date, :string
  end
end
