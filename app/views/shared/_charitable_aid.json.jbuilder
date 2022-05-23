json.extract! charitable_aid,
  :id,
  :name,
  :page_url,
  :openings,
  :receiver_count,
  :location,
  :about_aid
json.categories charitable_aid.charity_causes_names
json.extract! charitable_aid,
  :image_url,
  :youtube_url,
  :application_deadline,
  :published,
  :application_closed,
  :organization_id,
  :created_at,
  :updated_at
