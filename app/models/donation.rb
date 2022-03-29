# frozen_string_literal: true

class Donation < ApplicationRecord
  belongs_to :fundraising_campaign
  belongs_to :donor, class_name: "User"

  has_one :payment

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
