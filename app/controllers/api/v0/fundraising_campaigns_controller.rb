# frozen_string_literal: true

module Api
  module V0
    class FundraisingCampaignsController < ApiController
      before_action :authenticate_charity_member!, only: %i[create update destroy metrics]

      def index
        if params.key?(:organization_id)
          @fundraising_campaigns = paginate FundraisingCampaign.where(organization_id: params[:organization_id])
                                                               .includes([:charity_causes, :organization])
                                                               .order(created_at: :desc)
        else
          @fundraising_campaigns = paginate FundraisingCampaign.all
                                                               .includes([:charity_causes, :organization])
                                                               .order(created_at: :desc)
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

      def metrics
        fundraising_campaign = FundraisingCampaign.find(params[:id])
        metrics = FundraisingCampaigns::MetricsService.call(fundraising_campaign, params[:interval_start], params[:interval_end])

        render json: {
          id: fundraising_campaign.id,
          data: metrics
        }, status: :ok
      end

      private

      def fundraising_campaign_params
        fundraising_campaign_params = params.require(:fundraising_campaign).permit(fundraising_campaign_params_attributes)
        fundraising_campaign_params.merge!(categories_params)
      end

      def fundraising_campaign_params_attributes
        %i[
          name
          target_amount
          about_campaign
          image
          youtube_url
          start_datetime
          end_datetime
          published
        ]
      end

      def categories_params
        params.slice(:categories).permit(categories: [])
      end
    end
  end
end
