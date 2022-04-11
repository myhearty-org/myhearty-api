json.array!(@volunteer_events) do |volunteer_event|
  json.partial! "shared/volunteer_event", volunteer_event: volunteer_event
end
