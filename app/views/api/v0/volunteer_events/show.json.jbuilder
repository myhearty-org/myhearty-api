json.partial! "shared/volunteer_event", volunteer_event: @volunteer_event
if current_member
  json.image_data @volunteer_event.image_data
end
json.organization do
  json.partial! "api/v0/shared/organization", organization: @volunteer_event.organization
end
