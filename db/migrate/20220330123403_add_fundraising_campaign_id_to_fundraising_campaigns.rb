class AddFundraisingCampaignIdToFundraisingCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :fundraising_campaigns, :stripe_product_id, :string

    add_column :fundraising_campaigns, :fundraising_campaign_id, :string, null: false

    add_index :fundraising_campaigns, :fundraising_campaign_id, unique: true
  end
end
