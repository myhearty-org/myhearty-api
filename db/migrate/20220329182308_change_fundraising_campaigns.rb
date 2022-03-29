class ChangeFundraisingCampaigns < ActiveRecord::Migration[7.0]
  def change
    change_column_null :fundraising_campaigns, :target_amount, true
    change_column_default :fundraising_campaigns, :target_amount, from: 0, to: nil

    rename_column :fundraising_campaigns, :total_donors, :donor_count

    change_column :fundraising_campaigns, :start_datetime, :datetime, precision: 0
    change_column :fundraising_campaigns, :end_datetime, :datetime, precision: 0
  end
end
