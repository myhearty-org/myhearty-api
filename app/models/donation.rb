# frozen_string_literal: true

class Donation < ApplicationRecord
  belongs_to :fundraising_campaign
  belongs_to :user

  validates :fundraising_campaign, presence: true
  validates :user, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :payment_id, presence: true
  validates :payment_method, presence: true
  validates :date, presence: true
end
