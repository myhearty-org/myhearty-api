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
    end
  end
end
