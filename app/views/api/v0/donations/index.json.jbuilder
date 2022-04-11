json.array!(@donations) do |donation|
  json.partial! "donations/donation", donation: donation
  json.donor do
    json.partial! "api/v0/shared/user", user: donation.donor
  end
end
