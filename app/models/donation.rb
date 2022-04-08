# frozen_string_literal: true

class Donation < ApplicationRecord
  include RandomId

  belongs_to :fundraising_campaign
  belongs_to :donor, class_name: "User"

  has_one :payment

  validates :fundraising_campaign, presence: true, if: :fundraising_campaign_id_changed?
  validates :donor, presence: true, if: :donor_id_changed?
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 200 }

  delegate :organization, to: :fundraising_campaign

  scope :with_payment, -> { joins(:payment).select(DONATION_FIELDS) }

  DONATION_FIELDS = %w[
    donations.id
    donations.donation_id
    donations.amount
    donations.donor_id
    donations.fundraising_campaign_id
    payments.gross_amount
    payments.fee
    payments.net_amount
    payments.payment_method
    payments.status
    payments.completed_at
  ].freeze

  private_constant :DONATION_FIELDS
end
