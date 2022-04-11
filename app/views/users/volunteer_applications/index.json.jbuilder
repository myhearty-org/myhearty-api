json.array!(@volunteer_applications) do |volunteer_application|
  json.partial! "shared/volunteer_application", volunteer_application: volunteer_application
  json.volunteer_event do
    json.extract! volunteer_application.volunteer_event,
      :id,
      :name,
      :url,
      :openings,
      :volunteer_count,
      :location,
      :image_url,
      :youtube_url,
      :start_datetime,
      :end_datetime,
      :application_deadline,
      :organization_id
  end
end
