# frozen_string_literal: true

module Api
  module V0
    class DonationsController < ApiController
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index]

      def index
        @fundraising_campaign = FundraisingCampaign.find_by(id: params[:fundraising_campaign_id], organization: current_member.organization)

        return head :not_found unless @fundraising_campaign

        @donations = @fundraising_campaign.donations
                                          .with_payment
                                          .includes(:donor)
      end

      def show
        @donation = Donation.with_payment
                            .find(params[:id])

        return head :not_found unless user_donation? || organization_donation?
      end

      private

      def user_donation?
        @donation.donor == current_user if current_user
      end

      def organization_donation?
        @donation.organization == current_member.organization if current_member
      end
    end
  end
end
