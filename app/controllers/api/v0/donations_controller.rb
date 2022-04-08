# frozen_string_literal: true

module Api
  module V0
    class DonationsController < ApiController
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index]

      def index
        @fundraising_campaign = FundraisingCampaign.find(params[:fundraising_campaign_id])

        return head :unauthorized unless organization_fundraising_campaign?

        @donations = @fundraising_campaign.donations.with_payment
      end

      def show
        @donation = Donation.with_payment.find(params[:id])

        return head :unauthorized unless user_donation? || organization_donation?
      end

      private

      def organization_fundraising_campaign?
        @fundraising_campaign.organization.members.include?(current_member)
      end

      def user_donation?
        @donation.donor == current_user
      end

      def organization_donation?
        @donation.organization.members.include?(current_member)
      end
    end
  end
end
