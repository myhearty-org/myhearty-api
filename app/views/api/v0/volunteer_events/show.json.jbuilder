json.partial! "shared/volunteer_event", volunteer_event: @volunteer_event
if current_member
  json.image_data @volunteer_event.image_data
  json.confirmation_email_body @volunteer_event.confirmation_email_body
end
json.organization do
  json.partial! "api/v0/shared/organization", organization: @volunteer_event.organization
end
