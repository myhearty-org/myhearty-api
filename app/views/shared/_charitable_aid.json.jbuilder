json.extract! charitable_aid,
  :id,
  :name,
  :url,
  :openings,
  :receiver_count,
  :location,
  :about_aid
json.categories charitable_aid.charity_causes.map(&:display_name)
json.extract! charitable_aid,
  :image_url,
  :youtube_url,
  :application_deadline,
  :published,
  :organization_id,
  :created_at,
  :updated_at
