# frozen_string_literal: true

class CharityCause < ApplicationRecord
  has_many :charitables_charity_causes, dependent: :delete_all
  has_many :organizations, through: :charitables_charity_causes, source: :charitable, source_type: "Organization"
  has_many :fundraising_campaigns, through: :charitables_charity_causes, source: :charitable, source_type: "FundraisingCampaign"
  has_many :volunteer_events, through: :charitables_charity_causes, source: :charitable, source_type: "VolunteerEvent"
  has_many :charitable_aids, through: :charitables_charity_causes, source: :charitable, source_type: "CharitableAid"
end
