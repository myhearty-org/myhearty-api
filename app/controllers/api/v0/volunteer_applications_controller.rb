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
    end
  end
end
