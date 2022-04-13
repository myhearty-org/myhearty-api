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
  end
end
