# frozen_string_literal: true

module Api
  module V0
    class FundraisingCampaignsController < ApiController
      def index
        if params.key?(:organization_id)
          organization = Organization.find(params[:organization_id])
          @fundraising_campaigns = organization.fundraising_campaigns
        else
          @fundraising_campaigns = FundraisingCampaign.all
        end
      end

      def show
        @fundraising_campaign = FundraisingCampaign.find(params[:id])
      end

      def create
        @organization = Organization.find(params[:organization_id])
        result = FundraisingCampaigns::CreateService.call(current_member, @organization, fundraising_campaign_params)
        @fundraising_campaign = result.record

        if result.success?
          render :show, status: :created
        elsif @fundraising_campaign&.errors&.any?
          error_invalid_params(@fundraising_campaign)
        else
          render_error_response(message: result.message, http_status: result.http_status)
        end
      end

      private

      def fundraising_campaign_params
        params.require(:fundraising_campaign).permit(fundraising_campaign_params_attributes)
      end

      def fundraising_campaign_params_attributes
        %i[
          name
          target_amount
          location
          about_campaign
          main_image
          youtube_url
          start_datetime
          end_datetime
          published
        ]
      end
    end
  end
end
