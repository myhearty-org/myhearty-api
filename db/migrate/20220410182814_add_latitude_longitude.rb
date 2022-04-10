class AddLatitudeLongitude < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :latitude, :decimal, precision: 13, scale: 9
    add_column :organizations, :longitude, :decimal, precision: 13, scale: 9
    add_index :organizations, [:latitude, :longitude]

    add_column :fundraising_campaigns, :latitude, :decimal, precision: 13, scale: 9
    add_column :fundraising_campaigns, :longitude, :decimal, precision: 13, scale: 9
    add_index :fundraising_campaigns, [:latitude, :longitude]

    add_column :volunteer_events, :latitude, :decimal, precision: 13, scale: 9
    add_column :volunteer_events, :longitude, :decimal, precision: 13, scale: 9
    add_index :volunteer_events, [:latitude, :longitude]

    add_column :charitable_aids, :latitude, :decimal, precision: 13, scale: 9
    add_column :charitable_aids, :longitude, :decimal, precision: 13, scale: 9
    add_index :charitable_aids, [:latitude, :longitude]
  end
end
