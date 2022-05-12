Geocoder.configure(
  lookup: :geoapify,
  api_key: Rails.application.credentials.geoapify.api_key,
  timeout: 15,
  limit: 1,
  filter: "countrycode:my",
  bias: "countrycode:my",
  distances: :spherical,
  units: :km,
  use_https: true,
  always_raise: []
  # cache: nil,
  # cache_options: {
  #   expiration: 2.days,
  #   prefix: 'geocoder:'
  # }
)
