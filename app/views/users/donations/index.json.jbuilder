json.array!(@donations) do |donation|
  json.partial! "shared/donation", donation: donation
  json.fundraising_campaign do
    json.extract! donation.fundraising_campaign,
      :id,
      :name,
      :page_url
    json.target_amount donation.fundraising_campaign.target_amount.to_f / 100
    json.total_raised_amount donation.fundraising_campaign.total_raised_amount.to_f / 100
    json.extract! donation.fundraising_campaign,
      :donor_count,
      :image_url,
      :start_datetime,
      :end_datetime,
      :organization_id
  end
end
