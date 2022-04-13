json.extract! fundraising_campaign,
  :id,
  :name,
  :url,
  :target_amount,
  :total_raised_amount,
  :donor_count,
  :about_campaign
json.categories fundraising_campaign.charity_causes.map(&:display_name)
json.extract! fundraising_campaign,
  :image_url,
  :youtube_url,
  :start_datetime,
  :end_datetime,
  :published,
  :organization_id,
  :created_at,
  :updated_at
