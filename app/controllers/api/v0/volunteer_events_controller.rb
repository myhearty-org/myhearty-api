# frozen_string_literal: true

module Api
  module V0
    class VolunteerEventsController < ApiController
      before_action :authenticate_member!, only: %i[create update destroy]

      def index
        if params.key?(:organization_id)
          @volunteer_events = VolunteerEvent.where(organization_id: params[:organization_id])
        else
          @volunteer_events = VolunteerEvent.all
                                            .includes(:organization)
        end
      end

      def show
        @volunteer_event = VolunteerEvent.find(params[:id])
      end

      def create
        result = VolunteerEvents::CreateService.call(current_member, volunteer_event_params)
        @volunteer_event = result.record

        if result.success?
          render :show, status: :created
        else
          render_error(result.json, result.http_status)
        end
      end

      def update
        @volunteer_event = VolunteerEvent.find(params[:id])
        result = VolunteerEvents::UpdateService.call(current_member, @volunteer_event, volunteer_event_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
        end
      end

      def destroy
        result = VolunteerEvents::DestroyService.call(current_member, params[:id])

        if result.success?
          head :no_content
        else
          render_error(result.json, result.http_status)
        end
      end

      private

      def volunteer_event_params
        params.require(:volunteer_event).permit(volunteer_event_params_attributes)
      end

      def volunteer_event_params_attributes
        %i[
          name
          openings
          location
          about_event
          image
          youtube_url
          start_datetime
          end_datetime
          application_deadline
          published
        ]
      end
    end
  end
end
