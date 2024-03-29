json.extract! organization,
  :id,
  :name,
  :slug,
  :page_url,
  :location,
  :email
json.contact_no Phonelib.parse(organization.contact_no).national
json.extract! organization,
  :website_url,
  :facebook_url,
  :youtube_url,
  :person_in_charge_name,
  :avatar_url,
  :video_url,
  :image_url
json.categories organization.charity_causes_names
json.extract! organization,
  :about_us,
  :programmes_summary,
  :charity,
  :created_at,
  :updated_at
