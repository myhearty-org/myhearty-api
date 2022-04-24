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

  scope :pending, -> { where(status: "pending") }
  scope :succeeded, -> { where(status: "succeeded") }
  scope :failed, -> { where(status: "failed") }

  counter_culture :fundraising_campaign,
                  column_name: ->(payment) { payment.first_successful_payment_from_donor? ? :donor_count : nil },
                  touch: true
  after_update :index_donor_count, if: :first_successful_payment_from_donor?

  def first_successful_payment_from_donor?
    status == "succeeded" && Payment.where(user: user, fundraising_campaign: fundraising_campaign, status: "succeeded").limit(2).length == 1
  end

  private

  def index_donor_count
    Typesense::UpdateDonorCountJob.perform_async(id)
  end
end
