# frozen_string_literal: true

module Api
  module V0
    class VolunteerApplicationsController < ApiController
      def index
        volunteer_event = VolunteerEvent.find(params[:volunteer_event_id])
        @volunteer_applications = volunteer_event.volunteer_applications
      end

      def show
        @volunteer_application = VolunteerApplication.find(params[:id])
      end

      def create
        volunteer_event = VolunteerEvent.find(params[:volunteer_event_id])
        @volunteer_application = VolunteerApplications::CreateService.call(current_user, volunteer_event)

        if @volunteer_application.persisted?
          render :show, status: :created
        else
          error_invalid_params(@volunteer_application)
        end
      end

      def update
        @volunteer_application = VolunteerApplication.find(params[:id])
        result = VolunteerApplications::UpdateService.call(current_member, @volunteer_application, volunteer_application_params)

        if result.success?
          render :show, status: :ok
        elsif @volunteer_application.errors.any?
          error_invalid_params(@volunteer_application)
        else
          render_error_response(message: result.message, http_status: result.http_status)
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
    end
  end
end
