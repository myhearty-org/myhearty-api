class RemoveColumnsFromFundraisingCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :fundraising_campaigns, :location, :text
    remove_column :fundraising_campaigns, :latitude, :decimal, precision: 13, scale: 9
    remove_column :fundraising_campaigns, :longitude, :decimal, precision: 13, scale: 9
  end
end
