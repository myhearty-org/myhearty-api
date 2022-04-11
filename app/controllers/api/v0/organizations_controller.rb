# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      before_action :authenticate_organization_admin!, only: %i[update]
      before_action :authenticate_member!, only: %i[fundraising_campaigns volunteer_events charitable_aids]

      def index
        @organizations = Organization.all
                                     .includes(:charity_causes)
      end

      def show
        if params.key?(:id)
          @organization = Organization.find(params[:id])
        else
          authenticate_member!
          @organization = current_member.organization
        end
      end

      def update
        @organization = current_organization_admin.organization
        result = Organizations::UpdateService.call(@organization, organization_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
        end
      end

      def fundraising_campaigns
        @fundraising_campaigns = current_member.organization
                                               .fundraising_campaigns
                                               .includes(:charity_causes)
      end

      def volunteer_events
        @volunteer_events = current_member.organization
                                          .volunteer_events
                                          .includes(:charity_causes)
      end

      def charitable_aids
        @charitable_aids = current_member.organization
                                         .charitable_aids
                                         .includes(:charity_causes)
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
          image
          about_us
          programmes_summary
        ]
      end
    end
  end
end
