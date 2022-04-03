json.partial! "organizations/organization", organization: @organization
json.admin do
  json.partial! "members/member", member: @organization_admin
end
