# frozen_string_literal: true

module Api
  module V0
    class DonationsController < ApiController
      def index
        @fundraising_campaign = FundraisingCampaign.find(params[:fundraising_campaign_id])

        return head :unauthorized unless organization_fundraising_campaign?

        @donations = @fundraising_campaign.donations.with_payment
      end

      private

      def organization_fundraising_campaign?
        @fundraising_campaign.organization.members.include?(current_member)
      end
    end
  end
end
