class RemoveUrls < ActiveRecord::Migration[7.0]
  def change
    remove_column :fundraising_campaigns, :url, :string
    remove_column :volunteer_events, :url, :string
    remove_column :charitable_aids, :url, :string
  end
end
