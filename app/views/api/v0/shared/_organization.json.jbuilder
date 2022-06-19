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
  :image_url,
  :charity
