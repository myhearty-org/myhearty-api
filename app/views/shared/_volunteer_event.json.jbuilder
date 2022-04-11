json.extract! volunteer_event,
  :id,
  :name,
  :url,
  :openings,
  :volunteer_count,
  :location,
  :about_event
json.categories volunteer_event.charity_causes.map(&:display_name)
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
