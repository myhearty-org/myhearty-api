json.partial! "shared/organization", organization: @organization
json.admin do
  json.partial! "shared/member", member: @organization_admin
end
