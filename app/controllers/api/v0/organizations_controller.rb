# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      skip_forgery_protection only: %i[index]

      def index
        @organizations = Organization.all
      end
    end
  end
end
