json.array!(@charitable_aid_applications) do |charitable_aid_application|
  json.partial! "shared/charitable_aid_application", charitable_aid_application: charitable_aid_application
  json.receiver do
    json.partial! "api/v0/shared/user", user: charitable_aid_application.receiver
  end
end
