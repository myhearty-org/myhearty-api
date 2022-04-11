json.partial! "volunteer_events/volunteer_event", volunteer_event: @volunteer_event
json.organization do
  json.extract! @volunteer_event.organization,
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
