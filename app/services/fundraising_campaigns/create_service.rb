# frozen_string_literal: true

module FundraisingCampaigns
  class CreateService < BaseService
    def initialize(member, params)
      @member = member
      @params = params
    end

    def call
      fundraising_campaign = member.organization.fundraising_campaigns.new(params)

      if fundraising_campaign.save
        success(record: fundraising_campaign)
      else
        error_invalid_params(fundraising_campaign)
      end
    end

    private

    attr_reader :member, :params
  end
end
