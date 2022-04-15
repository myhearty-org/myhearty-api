json.extract! fundraising_campaign,
  :id,
  :name,
  :page_url,
  :target_amount,
  :total_raised_amount,
  :donor_count,
  :about_campaign
json.categories fundraising_campaign.charity_causes_names
json.extract! fundraising_campaign,
  :charity_causes_names,
  :image_url,
  :youtube_url,
  :start_datetime,
  :end_datetime,
  :published,
  :organization_id,
  :created_at,
  :updated_at
