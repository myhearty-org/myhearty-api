# frozen_string_literal: true

module Api
  module V0
    class VolunteerApplicationsController < ApiController
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index update]

      def index
        @volunteer_event = VolunteerEvent.find(params[:volunteer_event_id])

        return head :unauthorized unless organization_volunteer_event?

        @volunteer_applications = @volunteer_event.volunteer_applications
      end

      def show
        @volunteer_application = VolunteerApplication.find(params[:id])

        return head :unauthorized unless user_volunteer_application? || organization_volunteer_application?
      end

      def update
        @volunteer_application = VolunteerApplication.find(params[:id])
        result = VolunteerApplications::UpdateService.call(current_member, @volunteer_application, volunteer_application_params)

        if result.success?
          render :show, status: :ok
        elsif @volunteer_application.errors.any?
          error_invalid_params(@volunteer_application)
        else
          render_error(result.json, result.http_status)
        end
      end

      private

      def volunteer_application_params
        params.require(:volunteer_application).permit(volunteer_application_params_attributes)
      end

      def volunteer_application_params_attributes
        %i[
          status
          attendance
        ]
      end

      def organization_volunteer_event?
        @volunteer_event.organization.members.include?(current_member)
      end

      def user_volunteer_application?
        @volunteer_application.volunteer == current_user
      end

      def organization_volunteer_application?
        @volunteer_application.organization.members.include?(current_member)
      end
    end
  end
end
