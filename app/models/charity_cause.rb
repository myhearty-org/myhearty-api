# frozen_string_literal: true

class CharityCause < ApplicationRecord
  has_many :charitable_categories, dependent: :delete_all
  has_many :organizations, through: :charitable_categories, source: :charitable, source_type: "Organization"
  has_many :fundraising_campaigns, through: :charitable_categories, source: :charitable, source_type: "FundraisingCampaign"
  has_many :volunteer_events, through: :charitable_categories, source: :charitable, source_type: "VolunteerEvent"
  has_many :charitable_aids, through: :charitable_categories, source: :charitable, source_type: "CharitableAid"
end
