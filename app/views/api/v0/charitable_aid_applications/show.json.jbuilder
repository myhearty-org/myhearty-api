json.partial! "charitable_aid_applications/charitable_aid_application", charitable_aid_application: @charitable_aid_application
json.receiver do
  json.partial! "api/v0/shared/user", user: @charitable_aid_application.receiver
end
