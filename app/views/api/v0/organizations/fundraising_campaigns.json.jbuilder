json.array!(@fundraising_campaigns) do |fundraising_campaign|
  json.partial! "shared/fundraising_campaign", fundraising_campaign: fundraising_campaign
end
