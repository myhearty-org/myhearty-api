# frozen_string_literal: true

module Api
  module V0
    class CharitableAidApplicationsController < ApiController
      def index
        @charitable_aid = CharitableAid.find(params[:charitable_aid_id])

        return head :unauthorized unless organization_charitable_aid?

        @charitable_aid_applications = @charitable_aid.charitable_aid_applications
      end

      def show
        @charitable_aid_application = CharitableAidApplication.find(params[:id])

        return head :unauthorized unless user_charitable_aid_application? || organization_charitable_aid_application?
      end

      private

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
