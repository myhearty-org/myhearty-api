# frozen_string_literal: true

module Api
  module V0
    class FundraisingCampaignsController < ApiController
      before_action :authenticate_member!, only: %i[create update destroy]

      def index
        if params.key?(:organization_id)
          @fundraising_campaigns = FundraisingCampaign.where(organization_id: params[:organization_id])
        else
          @fundraising_campaigns = FundraisingCampaign.all.includes(:organization)
        end
      end

      def show
        @fundraising_campaign = FundraisingCampaign.find(params[:id])
      end

      def create
        result = FundraisingCampaigns::CreateService.call(current_member, fundraising_campaign_params)
        @fundraising_campaign = result.record

        if result.success?
          render :show, status: :created
        else
          render_error(result.json, result.http_status)
        end
      end

      def update
        @fundraising_campaign = FundraisingCampaign.find(params[:id])
        result = FundraisingCampaigns::UpdateService.call(current_member, @fundraising_campaign, fundraising_campaign_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
        end
      end

      def destroy
        result = FundraisingCampaigns::DestroyService.call(current_member, params[:id])

        if result.success?
          head :no_content
        else
          render_error(result.json, result.http_status)
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
          image
          youtube_url
          start_datetime
          end_datetime
          published
        ]
      end
    end
  end
end
