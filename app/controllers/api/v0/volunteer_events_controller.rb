# frozen_string_literal: true

module Api
  module V0
    class VolunteerEventsController < ApiController
      def index
        if params.key?(:organization_id)
          organization = Organization.find(params[:organization_id])
          @volunteer_events = organization.volunteer_events
        else
          @volunteer_events = VolunteerEvent.all
        end
      end

      def show
        @volunteer_event = VolunteerEvent.find(params[:id])
      end
    end
  end
end
