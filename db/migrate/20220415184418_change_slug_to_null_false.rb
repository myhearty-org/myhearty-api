class ChangeSlugToNullFalse < ActiveRecord::Migration[7.0]
  def change
    change_column :organizations, :slug, :string, null: false
    change_column :fundraising_campaigns, :slug, :string, null: false
    change_column :volunteer_events, :slug, :string, null: false
    change_column :charitable_aids, :slug, :string, null: false
  end
end
