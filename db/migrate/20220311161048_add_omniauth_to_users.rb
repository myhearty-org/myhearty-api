class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :name
      t.string :avatar
      t.string :facebook_username
      t.string :google_oauth2_username
    end

    add_index :users, :facebook_username
    add_index :users, :google_oauth2_username
  end
end
