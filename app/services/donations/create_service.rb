# frozen_string_literal: true

module Donations
  class CreateService < BaseService
    def initialize(donor, fundraising_campaign, amount)
      @donor = donor
      @fundraising_campaign = fundraising_campaign
      @amount = amount
    end

    def call
      donation = Donation.new(donor: donor, fundraising_campaign: fundraising_campaign, amount: amount)
      donation.save
      donation
    end

    private

    attr_reader :donor, :fundraising_campaign, :amount
  end
end
