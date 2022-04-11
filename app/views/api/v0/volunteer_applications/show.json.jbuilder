json.partial! "volunteer_applications/volunteer_application", volunteer_application: @volunteer_application
json.volunteer do
  json.partial! "api/v0/shared/user", user: @volunteer_application.volunteer
end
