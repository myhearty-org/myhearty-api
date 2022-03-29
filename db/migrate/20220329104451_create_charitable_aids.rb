class CreateCharitableAids < ActiveRecord::Migration[7.0]
  def change
    create_table :charitable_aids do |t|
      t.string :name, limit: 255, null: false
      t.string :url
      t.integer :openings
      t.integer :receiver_count, default: 0, null: false
      t.text :location
      t.text :about_aid
      t.string :main_image
      t.string :youtube_url
      t.datetime :application_deadline, precision: 0
      t.boolean :published, default: false, null: false
      t.timestamps
    end

    add_reference :charitable_aids, :organization, foreign_key: { on_delete: :cascade }, null: false
  end
end
