json.array!(@donations) do |donation|
  json.partial! "shared/donation", donation: donation
  json.donor do
    json.partial! "api/v0/shared/user", user: donation.donor
  end
end
