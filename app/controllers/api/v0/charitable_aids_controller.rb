# frozen_string_literal: true

module Api
  module V0
    class CharitableAidsController < ApiController
      def index
        if params.key?(:organization_id)
          organization = Organization.find(params[:organization_id])
          @charitable_aids = organization.charitable_aids
        else
          @charitable_aids = CharitableAid.all
        end
      end

      def show
        @charitable_aid = CharitableAid.find(params[:id])
      end
    end
  end
end
