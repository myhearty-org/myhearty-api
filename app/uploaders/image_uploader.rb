# frozen_string_literal: true

class ImageUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/png image/webp].freeze
  MAX_SIZE = 10 * 1024 * 1024
  MAX_DIMENSIONS = [5000, 5000].freeze

  THUMBNAILS = {
    small: [300, 300],
    medium: [600, 600],
    large: [800, 800]
  }.freeze

  plugin :remove_attachment
  plugin :pretty_location, class_underscore: true
  plugin :validation_helpers

  Attacher.validate do
    validate_size 0..MAX_SIZE
    validate_mime_type ALLOWED_TYPES
  end

  plugin :default_url

  Attacher.default_url do
    case name
    when :avatar
      "https://www.gravatar.com/avatar/?d=mp"
    when :image
      "https://fakeimg.pl/640x360/"
    end
  end
end
