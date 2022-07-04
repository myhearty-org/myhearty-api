# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :organization

  has_secure_token :token, length: 36
end
