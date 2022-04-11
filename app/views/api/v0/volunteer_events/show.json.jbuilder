json.partial! "shared/volunteer_event", volunteer_event: @volunteer_event
json.organization do
  json.partial! "api/v0/shared/organization", organization: @volunteer_event.organization
end
