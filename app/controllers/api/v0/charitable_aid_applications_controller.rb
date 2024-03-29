# frozen_string_literal: true

module Api
  module V0
    class CharitableAidApplicationsController < ApiController
      prepend_before_action :authenticate_with_api_key, only: %i[show index update]
      before_action :authenticate_user_or_member!, only: %i[show]
      before_action :authenticate_member!, only: %i[index update]

      def index
        @charitable_aid = CharitableAid.where(organization: current_member.organization).find(params[:charitable_aid_id])

        return head :not_found unless @charitable_aid

        @charitable_aid_applications = paginate @charitable_aid.charitable_aid_applications
                                                               .includes(:receiver)
                                                               .order(created_at: :desc)
      end

      def show
        @charitable_aid_application = CharitableAidApplication.find(params[:id])

        return head :not_found unless user_charitable_aid_application? || organization_charitable_aid_application?
      end

      def update
        @charitable_aid_application = CharitableAidApplication.find(params[:id])
        result = CharitableAidApplications::UpdateService.call(current_member, @charitable_aid_application, charitable_aid_application_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
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

      def user_charitable_aid_application?
        @charitable_aid_application.receiver == current_user if current_user
      end

      def organization_charitable_aid_application?
        @charitable_aid_application.organization == current_member.organization if current_member
      end
    end
  end
end
