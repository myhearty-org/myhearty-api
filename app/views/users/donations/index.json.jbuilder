json.array!(@donations) do |donation|
  json.partial! "shared/donation", donation: donation
  json.fundraising_campaign do
    json.extract! donation.fundraising_campaign,
      :id,
      :name,
      :url,
      :target_amount,
      :total_raised_amount,
      :donor_count,
      :image_url,
      :start_datetime,
      :end_datetime,
      :organization_id
  end
end
