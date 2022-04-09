json.array!(@charitable_aid_applications) do |charitable_aid_application|
  json.partial! "charitable_aid_applications/charitable_aid_application", charitable_aid_application: charitable_aid_application
end
