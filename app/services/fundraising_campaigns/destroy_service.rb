# frozen_string_literal: true

module FundraisingCampaigns
  class DestroyService < BaseService
    def initialize(member, id)
      @member = member
      @id = id
    end

    def call
      fundraising_campaign = FundraisingCampaign.find_by(id: id, organization: member.organization)

      return error(http_status: :not_found) unless fundraising_campaign

      return error_unallowed_delete if fundraising_campaign.published?

      fundraising_campaign.destroy
      success
    end

    private

    attr_reader :member, :id

    def error_unallowed_delete
      error(
        json: { code: "published_fundraising_campaign_not_deletable" },
        http_status: :forbidden
      )
    end
  end
end
