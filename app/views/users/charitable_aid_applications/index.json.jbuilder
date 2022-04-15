json.array!(@charitable_aid_applications) do |charitable_aid_application|
  json.partial! "shared/charitable_aid_application", charitable_aid_application: charitable_aid_application
  json.charitable_aid do
    json.extract! charitable_aid_application.charitable_aid,
      :id,
      :name,
      :page_url,
      :openings,
      :receiver_count,
      :location,
      :image_url,
      :youtube_url,
      :application_deadline,
      :organization_id
  end
end
