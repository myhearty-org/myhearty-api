# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      def index
        @organizations = Organization.all
      end

      def show
        @organization = Organization.find(params[:id])
      end
    end
  end
end
