json.array!(@charitable_aids) do |charitable_aid|
  json.partial! "charitable_aids/charitable_aid", charitable_aid: charitable_aid

  if charitable_aid.association_cached?(:organization)
    json.organization do
      json.extract! charitable_aid.organization,
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
