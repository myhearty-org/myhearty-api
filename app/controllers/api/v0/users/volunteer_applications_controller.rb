# frozen_string_literal: true

module Api
  module V0
    module Users
      class VolunteerApplicationsController < ApiController
        before_action :authenticate_user!

        def index
          @volunteer_applications = current_user.volunteer_applications
        end

        def applied
          volunteer_event_id = params[:volunteer_event_id]
          volunteer_application = VolunteerApplication.find_by(volunteer: current_user, volunteer_event_id: volunteer_event_id)

          volunteer_application ? head(:no_content) : head(:not_found)
        end

        def apply
          volunteer_event = VolunteerEvent.find(params[:volunteer_event_id])
          result = VolunteerApplications::CreateService.call(current_user, volunteer_event)
          @volunteer_application = result.record

          if result.success?
            render :show, status: :created
          else
            render_error_response(message: result.message, http_status: result.http_status)
          end
        end

        def unapply
          volunteer_event = VolunteerEvent.find(params[:volunteer_event_id])
          result = VolunteerApplications::DestroyService.call(current_user, volunteer_event)

          if result.success?
            head :no_content
          else
            render_error_response(message: result.message, http_status: result.http_status)
          end
        end
      end
    end
  end
end
