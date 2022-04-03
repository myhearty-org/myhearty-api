# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      before_action :authenticate_organization_admin!, only: %i[update]

      skip_forgery_protection only: %i[index show]

      def index
        @organizations = Organization.all
      end

      def show
        @organization = Organization.find(params[:id])
      end

      def update
        @organization = Organization.find(params[:id])
        result = Organizations::UpdateService.call(current_organization_admin, @organization, organization_params)

        if result.success?
          render :show, status: :ok
        elsif @organization.errors.any?
          error_invalid_params(@organization)
        else
          render_error_response(message: result.message, http_status: result.http_status)
        end
      end

      private

      def organization_params
        params.require(:organization).permit(organization_params_attributes)
      end

      def organization_params_attributes
        %i[
          name
          location
          email
          contact_no
          website_url
          facebook_url
          youtube_url
          person_in_charge_name
          avatar
          video_url
          images
          about_us
          programmes_summary
        ]
      end
    end
  end
end
