# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :donation
  belongs_to :fundraising_campaign
  belongs_to :user

  validtaes :stripe_checkout_session_id, presence: true
  validates :gross_amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :fee, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :net_amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :completed_at, comparison: { greater_than_or_equal_to: :created_at }
end
