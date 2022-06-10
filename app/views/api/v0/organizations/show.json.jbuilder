json.partial! "shared/organization", organization: @organization
if @authenticated_organization
  json.stripe_onboarded @organization.stripe_onboarded?
end
