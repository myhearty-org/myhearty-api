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
  end
end
