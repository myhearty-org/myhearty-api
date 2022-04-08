# frozen_string_literal: true

module FundraisingCampaigns
  class CreateService < BaseService
    def initialize(member, organization, params)
      @member = member
      @organization = organization
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      fundraising_campaign = organization.fundraising_campaigns.new(params)

      if fundraising_campaign.save
        success(record: fundraising_campaign)
      else
        error(record: fundraising_campaign)
      end
    end

    private

    attr_reader :member, :organization, :params

    def organization_member?
      organization.members.include?(member)
    end

    def error_no_permissions
      error(
        json: { message: "No permission to create fundraising campaign" },
        http_status: :unauthorized
      )
    end
  end
end
