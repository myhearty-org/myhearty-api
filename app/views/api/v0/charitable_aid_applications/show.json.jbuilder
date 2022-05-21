json.partial! "shared/charitable_aid_application", charitable_aid_application: @charitable_aid_application
json.receiver do
  json.partial! "api/v0/shared/user_profile", user: @charitable_aid_application.receiver
end
