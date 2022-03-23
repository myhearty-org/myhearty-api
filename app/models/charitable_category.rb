# frozen_string_literal: true

class CharitableCategory < ApplicationRecord
  belongs_to :charity_cause
  belongs_to :charitable, polymorphic: true
end
