class CreateCharitableAidApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :charitable_aid_applications do |t|
      t.integer :status, default: 0, null: false
      t.datetime :status_updated_at, null: false
      t.timestamps
    end

    add_reference :charitable_aid_applications, :charitable_aid, foreign_key: true, null: false
    add_reference :charitable_aid_applications, :receiver, foreign_key: { to_table: :users }, null: false

    add_index :charitable_aid_applications, :status
    add_index :charitable_aid_applications, [:charitable_aid_id, :receiver_id], unique: true, name: "index_charitable_aid_applications"
  end
end
