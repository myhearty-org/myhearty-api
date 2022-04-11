json.array!(@volunteer_events) do |volunteer_event|
  json.partial! "shared/volunteer_event", volunteer_event: volunteer_event

  if volunteer_event.association_cached?(:organization)
    json.organization do
      json.partial! "api/v0/shared/organization", organization: volunteer_event.organization
    end
  end
end
