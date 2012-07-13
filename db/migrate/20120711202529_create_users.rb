class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twi_name
      t.string :twi_screen_name
      t.integer :twi_user_id
      t.text :twi_profile_img_url
      t.string :twi_oauth_token
      t.string :twi_oauth_secret

      t.timestamps
    end
  end
end
