# frozen_string_literal: true

module FundraisingCampaigns
  class UpdateService < BaseService
    def initialize(member, fundraising_campaign, params)
      @member = member
      @fundraising_campaign = fundraising_campaign
      @params = params
    end

    def call
      return error(http_status: :not_found) unless organization_member?

      params.extract!(*unallowed_params_for_published) if fundraising_campaign.published?

      if fundraising_campaign.update(params)
        success
      else
        error_invalid_params(fundraising_campaign)
      end
    end

    private

    attr_reader :member, :fundraising_campaign, :params

    def organization_member?
      fundraising_campaign.organization == member.organization
    end

    def unallowed_params_for_published
      %i[
        name
        target_amount
        start_datetime
        end_datetime
        published
      ]
    end
  end
end
