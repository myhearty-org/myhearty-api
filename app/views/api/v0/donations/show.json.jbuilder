json.partial! "donations/donation", donation: @donation
json.donor do
  json.extract! @donation.donor,
    :id,
    :name,
    :email
end
