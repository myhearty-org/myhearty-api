class CreateVolunteerEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :volunteer_events do |t|
      t.string :name, limit: 255, null: false
      t.string :url
      t.integer :openings
      t.integer :volunteer_count, default: 0, null: false
      t.text :location
      t.text :about_event
      t.string :main_image
      t.string :youtube_url
      t.datetime :start_datetime, precision: 0
      t.datetime :end_datetime, precision: 0
      t.datetime :sign_up_deadline, precision: 0
      t.boolean :published, default: false, null: false
      t.timestamps
    end

    add_reference :volunteer_events, :organization, foreign_key: { on_delete: :cascade }, null: false
  end
end
