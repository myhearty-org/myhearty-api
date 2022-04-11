json.partial! "charitable_aid_applications/charitable_aid_application", charitable_aid_application: @charitable_aid_application
json.charitable_aid do
  json.extract! @charitable_aid,
    :id,
    :name,
    :url,
    :openings,
    :receiver_count,
    :location,
    :image_url,
    :youtube_url,
    :application_deadline,
    :organization_id
end
