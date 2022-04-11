json.array!(@fundraising_campaigns) do |fundraising_campaign|
  json.partial! "fundraising_campaigns/fundraising_campaign", fundraising_campaign: fundraising_campaign

  if fundraising_campaign.association_cached?(:organization)
    json.organization do
      json.extract! fundraising_campaign.organization,
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
