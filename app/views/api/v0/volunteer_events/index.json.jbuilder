json.array!(@volunteer_events) do |volunteer_event|
  json.partial! "volunteer_events/volunteer_event", volunteer_event: volunteer_event
end
