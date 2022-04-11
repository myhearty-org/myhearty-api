json.array!(@fundraising_campaigns) do |fundraising_campaign|
  json.partial! "shared/fundraising_campaign", fundraising_campaign: fundraising_campaign

  if fundraising_campaign.association_cached?(:organization)
    json.organization do
      json.partial! "api/v0/shared/organization", organization: fundraising_campaign.organization
    end
  end
end
