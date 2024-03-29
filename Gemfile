# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.0.3"

gem "rails", "~> 7.0.1"

gem "pg", "~> 1.1"

gem "puma", "~> 5.0"

gem "redis", "~> 4.6"

gem "bootsnap", require: false

# Authentication libraries
gem "devise", "~> 4.8.1"
gem "omniauth", "~> 2.0"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "omniauth-facebook", "~> 9.0"
gem "omniauth-google-oauth2", "~> 1.0"

# API
gem "jbuilder", "~> 2.11"
gem "rack-cors", "~> 1.1"
gem "responders", "~> 3.0"

# Payments
gem "stripe", "~> 5.0"

# Background jobs
gem "sidekiq", "~> 6.4"

# Search engine
gem "typesense", "~> 0.13"

# Pagination
gem "kaminari", "~> 1.2"
gem "api-pagination", "~> 5.0"

# Files attachments
gem "shrine", "~> 3.0"
gem "shrine-url", "~> 2.4" # provides a fake storage to create a Shrine attachment defined by a custom URL.

# Storage
gem "aws-sdk-s3", "~> 1.0"

# Geocoding
gem "geocoder", "~> 1.7"

# Slugging and permalinks
gem "friendly_id", "~> 5.0"

# Group temporal data
gem "groupdate", "~> 6.1"

# Validations
gem "public_suffix", "~> 4.0"
gem "phonelib", "~> 0.6"

# Counter cache
gem "counter_culture", "~> 3.2"

# JSON
gem "oj", "~> 3.13"
gem "multi_json", "~> 1.15"

# HTTP Requests
gem "httparty", "~> 0.20"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "debase"
  gem "ruby-debug-ide"

  # Static code analyzer
  gem "rubocop", require: false

  # N + 1 queries checker
  gem "bullet"

  # Consistency check for database and active record validations
  gem "active_record_doctor", require: false
  gem "database_consistency", require: false

  # Generate fake data
  gem "faker", "~> 2.20"
end

group :development do
  # gem "spring"
end
