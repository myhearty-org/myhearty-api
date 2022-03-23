# frozen_string_literal: true

class CharityCause < ApplicationRecord
  has_many :charitable_categories, dependent: :delete_all
  has_many :organizations, through: :charitable_categories, source: :charitable, source_type: "Organization"
end
