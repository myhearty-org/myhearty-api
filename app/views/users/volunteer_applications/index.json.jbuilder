json.array!(@volunteer_applications) do |volunteer_application|
  json.partial! "volunteer_applications/volunteer_application", volunteer_application: volunteer_application
end
