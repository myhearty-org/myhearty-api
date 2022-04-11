json.array!(@organizations) do |organization|
  json.partial! "shared/organization", organization: organization
end
