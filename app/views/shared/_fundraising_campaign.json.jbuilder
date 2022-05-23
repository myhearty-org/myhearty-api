json.extract! fundraising_campaign,
  :id,
  :name,
  :page_url
json.target_amount fundraising_campaign.target_amount.to_f / 100
json.total_raised_amount fundraising_campaign.total_raised_amount.to_f / 100
json.extract! fundraising_campaign,
  :donor_count,
  :about_campaign
json.categories fundraising_campaign.charity_causes_names
json.extract! fundraising_campaign,
  :image_url,
  :youtube_url,
  :start_datetime,
  :end_datetime,
  :published,
  :ended,
  :organization_id,
  :created_at,
  :updated_at
