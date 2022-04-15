class AddSlugs < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :slug, :string
    add_index :organizations, :slug, unique: true

    add_column :fundraising_campaigns, :slug, :string
    add_index :fundraising_campaigns, :slug, unique: true

    add_column :volunteer_events, :slug, :string
    add_index :volunteer_events, :slug, unique: true

    add_column :charitable_aids, :slug, :string
    add_index :charitable_aids, :slug, unique: true
  end
end
