# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.0.3"

gem "rails", "~> 7.0.1"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "redis", "~> 4.0"

gem "bootsnap", require: false
gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "debase"
  gem "ruby-debug-ide"
  gem "rubocop", require: false
end

group :development do
  # gem "spring"
end
