# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :donation
  belongs_to :fundraising_campaign
  belongs_to :user

  validates :stripe_checkout_session_id, presence: true
  validates :gross_amount, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :fee, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :net_amount, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates_datetime :completed_at, allow_nil: true, after: :created_at, after_message: "must be after created at"
end
