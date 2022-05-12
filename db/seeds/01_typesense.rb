puts "Creating Typesense schema\n"

begin
  if TypesenseClient.collections["organizations"].retrieve
    TypesenseClient.collections["organizations"].delete
  end
rescue Typesense::Error::ObjectNotFound
end

organizations_schema = {
  name: "organizations",
  fields: [
    { name: "id", type: "string" },
    { name: "name", type: "string" },
    { name: "categories", type: "string[]", facet: true },
    { name: "about_us", type: "string" },
    { name: "location", type: "string" },
    { name: "coordinates", type: "geopoint" },
    { name: "charity", type: "bool", facet: true },
    { name: "page_url", type: "string", index: false, optional: true },
    { name: "image_url", type: "string", index: false, optional: true }
  ]
}

TypesenseClient.collections.create(organizations_schema)

begin
  if TypesenseClient.collections["fundraising_campaigns"].retrieve
    TypesenseClient.collections["fundraising_campaigns"].delete
  end
rescue Typesense::Error::ObjectNotFound
end

fundraising_campaigns_schema = {
  name: "fundraising_campaigns",
  fields: [
    { name: "id", type: "string" },
    { name: "name", type: "string" },
    { name: "categories", type: "string[]", facet: true },
    { name: "target_amount", type: "float", facet: true },
    { name: "total_raised_amount", type: "float" },
    { name: "donor_count", type: "int32" },
    { name: "organization", type: "string" },
    { name: "start_datetime", type: "int64" },
    { name: "end_datetime", type: "int64" },
    { name: "about_campaign", type: "string" },
    { name: "page_url", type: "string", index: false, optional: true },
    { name: "image_url", type: "string", index: false, optional: true }
  ]
}

TypesenseClient.collections.create(fundraising_campaigns_schema)

begin
  if TypesenseClient.collections["volunteer_events"].retrieve
    TypesenseClient.collections["volunteer_events"].delete
  end
rescue Typesense::Error::ObjectNotFound
end

volunteer_events_schema = {
  name: "volunteer_events",
  fields: [
    { name: "id", type: "string" },
    { name: "name", type: "string" },
    { name: "categories", type: "string[]", facet: true },
    { name: "openings", type: "int32", facet: true },
    { name: "volunteer_count", type: "int32" },
    { name: "organization", type: "string" },
    { name: "start_datetime", type: "int64", facet: true },
    { name: "end_datetime", type: "int64" },
    { name: "location", type: "string" },
    { name: "coordinates", type: "geopoint" },
    { name: "page_url", type: "string", index: false, optional: true },
    { name: "image_url", type: "string", index: false, optional: true }
  ]
}

TypesenseClient.collections.create(volunteer_events_schema)

begin
  if TypesenseClient.collections["charitable_aids"].retrieve
    TypesenseClient.collections["charitable_aids"].delete
  end
rescue Typesense::Error::ObjectNotFound
end

charitable_aids_schema = {
  name: "charitable_aids",
  fields: [
    { name: "id", type: "string" },
    { name: "name", type: "string" },
    { name: "categories", type: "string[]", facet: true },
    { name: "openings", type: "int32", facet: true },
    { name: "receiver_count", type: "int32" },
    { name: "organization", type: "string" },
    { name: "application_deadline", type: "int64", facet: true },
    { name: "location", type: "string" },
    { name: "coordinates", type: "geopoint" },
    { name: "page_url", type: "string", index: false, optional: true },
    { name: "image_url", type: "string", index: false, optional: true }
  ]
}

TypesenseClient.collections.create(charitable_aids_schema)

puts "Finished creating Typesense schema\n"
