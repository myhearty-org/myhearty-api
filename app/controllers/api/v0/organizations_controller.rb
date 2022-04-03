# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      skip_forgery_protection only: %i[index show]

      def index
        @organizations = Organization.all
      end

      def show
        @organization = Organization.find(params[:id])
      end
    end
  end
end
