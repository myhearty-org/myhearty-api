# frozen_string_literal: true

module Api
  module V0
    module Users
      class CharitableAidApplicationsController < ApiController
        before_action :authenticate_user!

        def index
          @charitable_aid_applications = current_user.charitable_aid_applications
        end

        def applied
          charitable_aid_id = params[:charitable_aid_id]
          charitable_aid_application = CharitableAidApplication.find_by(receiver: current_user, charitable_aid_id: charitable_aid_id)

          charitable_aid_application ? head(:no_content) : head(:not_found)
        end

        def apply
          charitable_aid = CharitableAid.find(params[:charitable_aid_id])
          result = CharitableAidApplications::CreateService.call(current_user, charitable_aid)
          @charitable_aid_application = result.record

          if result.success?
            render :show, status: :created
          else
            render_error_response(message: result.message, http_status: result.http_status)
          end
        end

        def unapply
          charitable_aid = CharitableAid.find(params[:charitable_aid_id])
          result = CharitableAidApplications::DestroyService.call(current_user, charitable_aid)

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
