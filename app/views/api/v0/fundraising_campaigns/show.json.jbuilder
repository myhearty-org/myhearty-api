json.partial! "shared/fundraising_campaign", fundraising_campaign: @fundraising_campaign
if current_member
  json.image_data @fundraising_campaign.image_data
end
json.organization do
  json.partial! "api/v0/shared/organization", organization: @fundraising_campaign.organization
end
