json.array!(@volunteer_events) do |volunteer_event|
  json.partial! "volunteer_events/volunteer_event", volunteer_event: volunteer_event

  if volunteer_event.association_cached?(:organization)
    json.organization do
      json.extract! volunteer_event.organization,
        :id,
        :name,
        :location,
        :email,
        :contact_no,
        :website_url,
        :facebook_url,
        :youtube_url,
        :person_in_charge_name,
        :avatar_url,
        :video_url,
        :image_url,
        :charity
    end
  end
end
