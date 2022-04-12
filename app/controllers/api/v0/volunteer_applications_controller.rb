# frozen_string_literal: true

module Api
  module V0
    class VolunteerApplicationsController < ApiController
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index update]

      def index
        @volunteer_event = VolunteerEvent.find_by(id: params[:volunteer_event_id], organization: current_member.organization)

        return head :not_found unless @volunteer_event

        @volunteer_applications = paginate @volunteer_event.volunteer_applications
                                                           .includes(:volunteer)
                                                           .order(created_at: :desc)
      end

      def show
        @volunteer_application = VolunteerApplication.find(params[:id])

        return head :not_found unless user_volunteer_application? || organization_volunteer_application?
      end

      def update
        @volunteer_application = VolunteerApplication.find(params[:id])
        result = VolunteerApplications::UpdateService.call(current_member, @volunteer_application, volunteer_application_params)

        if result.success?
          render :show, status: :ok
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

      def user_volunteer_application?
        @volunteer_application.volunteer == current_user if current_user
      end

      def organization_volunteer_application?
        @volunteer_application.organization == current_member.organization if current_member
      end
    end
  end
end
