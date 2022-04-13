# frozen_string_literal: true

module Api
  module V0
    class OrganizationsController < ApiController
      before_action :authenticate_organization_admin!, only: %i[update]
      before_action :authenticate_member!, only: %i[volunteer_events charitable_aids]
      before_action :authenticate_charity_member!, only: %i[fundraising_campaigns]

      def index
        @organizations = paginate Organization.all
                                              .includes(:charity_causes)
                                              .order(created_at: :desc)
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
        @fundraising_campaigns = paginate current_member.organization
                                                        .fundraising_campaigns
                                                        .includes(:charity_causes)
                                                        .order(created_at: :desc)
      end

      def volunteer_events
        @volunteer_events = paginate current_member.organization
                                                   .volunteer_events
                                                   .includes(:charity_causes)
                                                   .order(created_at: :desc)
      end

      def charitable_aids
        @charitable_aids = paginate current_member.organization
                                                  .charitable_aids
                                                  .includes(:charity_causes)
                                                  .order(created_at: :desc)
      end

      private

      def organization_params
        organization_params = params.require(:organization).permit(organization_params_attributes)
        organization_params.merge!(categories_params)
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

      def categories_params
        params.slice(:categories).permit(categories: [])
      end
    end
  end
end
