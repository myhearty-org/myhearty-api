class CreateFundraisingCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :fundraising_campaigns do |t|
      t.string :name, limit: 255, null: false
      t.string :url
      t.integer :target_amount, default: 0, null: false
      t.integer :total_raised_amount, default: 0, null: false
      t.integer :total_donors, default: 0, null: false
      t.text :location, limit: 255
      t.text :about_campaign
      t.string :main_image
      t.string :youtube_url
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :published, default: false, null: false
      t.timestamps
    end

    add_reference :fundraising_campaigns, :organization, foreign_key: { on_delete: :cascade }, null: false
  end
end
