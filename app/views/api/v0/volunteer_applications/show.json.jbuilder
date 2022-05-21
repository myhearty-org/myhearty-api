json.partial! "shared/volunteer_application", volunteer_application: @volunteer_application
json.volunteer do
  json.partial! "api/v0/shared/user_profile", user: @volunteer_application.volunteer
end
