# frozen_string_literal: true

module Api
  module V0
    class CharitableAidApplicationsController < ApiController
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index update]

      def index
        @charitable_aid = CharitableAid.find(params[:charitable_aid_id])

        return head :unauthorized unless organization_charitable_aid?

        @charitable_aid_applications = @charitable_aid.charitable_aid_applications
      end

      def show
        @charitable_aid_application = CharitableAidApplication.find(params[:id])

        return head :unauthorized unless user_charitable_aid_application? || organization_charitable_aid_application?
      end

      def update
        @charitable_aid_application = CharitableAidApplication.find(params[:id])
        result = CharitableAidApplications::UpdateService.call(current_member, @charitable_aid_application, charitable_aid_application_params)

        if result.success?
          render :show, status: :ok
        elsif @charitable_aid_application.errors.any?
          error_invalid_params(@charitable_aid_application)
        else
          render_error_response(message: result.message, http_status: result.http_status)
        end
      end

      private

      def charitable_aid_application_params
        params.require(:charitable_aid_application).permit(charitable_aid_application_params_attributes)
      end

      def charitable_aid_application_params_attributes
        %i[
          status
        ]
      end

      def organization_charitable_aid?
        @charitable_aid.organization.members.include?(current_member)
      end

      def user_charitable_aid_application?
        @charitable_aid_application.receiver == current_user
      end

      def organization_charitable_aid_application?
        @charitable_aid_application.organization.members.include?(current_member)
      end
    end
  end
end
