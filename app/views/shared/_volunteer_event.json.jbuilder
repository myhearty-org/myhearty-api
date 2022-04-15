json.extract! volunteer_event,
  :id,
  :name,
  :page_url,
  :openings,
  :volunteer_count,
  :location,
  :about_event
json.categories volunteer_event.charity_causes_names
json.extract! volunteer_event,
  :image_url,
  :youtube_url,
  :start_datetime,
  :end_datetime,
  :application_deadline,
  :published,
  :organization_id,
  :created_at,
  :updated_at
