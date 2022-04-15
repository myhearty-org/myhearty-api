# frozen_string_literal: true

module Donations
  class CreateService < BaseService
    def initialize(donor, fundraising_campaign, amount)
      @donor = donor
      @fundraising_campaign = fundraising_campaign
      @amount = amount
    end

    def call
      return error_not_published unless fundraising_campaign.published?

      return error_target_amount_reached if fundraising_campaign.target_amount_reached?

      donation = Donation.new(donor: donor, fundraising_campaign: fundraising_campaign, amount: amount)

      if donation.save
        success(record: donation)
      else
        error_invalid_params(donation)
      end
    end

    private

    attr_reader :donor, :fundraising_campaign, :amount

    def error_not_published
      error(
        json: { message: "Not published" },
        http_status: :unprocessable_entity
      )
    end

    def error_target_amount_reached
      error(
        json: { message: "Target amount reached" },
        http_status: :unprocessable_entity
      )
    end
  end
end
