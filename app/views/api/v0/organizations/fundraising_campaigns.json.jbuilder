json.array!(@fundraising_campaigns) do |fundraising_campaign|
  json.partial! "fundraising_campaigns/fundraising_campaign", fundraising_campaign: fundraising_campaign
end
