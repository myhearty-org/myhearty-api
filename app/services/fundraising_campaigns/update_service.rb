# frozen_string_literal: true

module FundraisingCampaigns
  class UpdateService < BaseService
    def initialize(member, fundraising_campaign, params)
      @member = member
      @fundraising_campaign = fundraising_campaign
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      @params = params.except(*unallowed_params_for_published) if fundraising_campaign.published?

      if fundraising_campaign.update(params)
        success
      else
        error
      end
    end

    private

    attr_reader :member, :fundraising_campaign, :params

    def organization_member?
      fundraising_campaign.organization.members.include?(member)
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

    def error_no_permissions
      error(
        message: "No permission to update fundraising campaign",
        http_status: :unauthorized
      )
    end
  end
end
