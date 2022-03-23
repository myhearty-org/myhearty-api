class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.text :location, null: false
      t.string :email, null: false
      t.string :contact_no, null: false
      t.string :website_url
      t.string :facebook_url
      t.string :youtube_url
      t.string :person_in_charge_name, null: false
      t.string :avatar_url
      t.string :video_url
      t.string :images, default: [], array: true
      t.text :about_us, null: false
      t.text :programmes_summary
      t.boolean :is_charity, default: false, null: false
      t.timestamps
    end

    add_index :organizations, :name
    add_index :organizations, :email, unique: true
    add_index :organizations, :website_url, unique: true
  end
end
