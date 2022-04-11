json.partial! "fundraising_campaigns/fundraising_campaign", fundraising_campaign: @fundraising_campaign
json.organization do
  json.partial! "api/v0/shared/organization", organization: @fundraising_campaign.organization
end
