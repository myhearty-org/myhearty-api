json.array!(@organizations) do |organization|
  json.partial! "organizations/organization", organization: organization
end
