# frozen_string_literal: true

module Api
  module V0
    module Users
      class CharitableAidApplicationsController < ApiController
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

          case result.http_status
          when :created
            render :show, status: :created
          when :not_modified
            head :not_modified
          end
        end
      end
    end
  end
end
