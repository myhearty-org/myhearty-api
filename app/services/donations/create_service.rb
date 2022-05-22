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

      return error_campaign_ended if fundraising_campaign.ended?

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
        json: { code: "fundraising_campaign_not_published" },
        http_status: :unprocessable_entity
      )
    end

    def error_campaign_ended
      error(
        json: { code: "fundraising_campaign_ended" },
        http_status: :unprocessable_entity
      )
    end
  end
end
