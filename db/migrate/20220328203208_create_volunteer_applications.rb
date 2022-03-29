class CreateVolunteerApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :volunteer_applications do |t|
      t.integer :status, default: 0, null: false
      t.datetime :status_updated_at, null: false
      t.integer :attendance, default: 0, null: false
      t.datetime :attendance_updated_at, null: false
      t.timestamps
    end

    add_reference :volunteer_applications, :volunteer_event, foreign_key: true, null: false
    add_reference :volunteer_applications, :volunteer, foreign_key: { to_table: :users }, null: false

    add_index :volunteer_applications, :status
    add_index :volunteer_applications, :attendance
    add_index :volunteer_applications, [:volunteer_event_id, :volunteer_id], unique: true, name: "index_volunteer_applications"
  end
end
