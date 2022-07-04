# frozen_string_literal: true

module Api
  module V0
    class DonationsController < ApiController
      prepend_before_action :authenticate_with_api_key, only: %i[show index]
      before_action :authenticate_user_or_charity_member!, only: %i[show]
      before_action :authenticate_charity_member!, only: %i[index]

      def index
        @fundraising_campaign = FundraisingCampaign.where(organization: current_member.organization).find(params[:fundraising_campaign_id])

        return head :not_found unless @fundraising_campaign

        @donations = paginate @fundraising_campaign.donations
                                                   .with_payment
                                                   .includes(:donor)
                                                   .order(created_at: :desc)
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
