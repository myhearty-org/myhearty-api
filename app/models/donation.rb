# frozen_string_literal: true

class Donation < ApplicationRecord
  include RandomId

  belongs_to :fundraising_campaign
  belongs_to :donor, class_name: "User"

  has_one :payment

  validates :fundraising_campaign, presence: true, if: :fundraising_campaign_id_changed?
  validates :donor, presence: true, if: :donor_id_changed?
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
