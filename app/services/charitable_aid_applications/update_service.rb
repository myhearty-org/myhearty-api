# frozen_string_literal: true

module CharitableAidApplications
  class UpdateService < BaseService
    def initialize(member, charitable_aid_application, params)
      @member = member
      @charitable_aid_application = charitable_aid_application
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      return error_enough_receivers if enough_receivers?

      if charitable_aid_application.update(params)
        success
      else
        error_invalid_params(charitable_aid_application)
      end
    end

    private

    attr_reader :member, :charitable_aid_application, :params

    def organization_member?
      charitable_aid_application.organization == member.organization
    end

    def enough_receivers?
      params[:status] == "approved" && receiver_count_exceeded?
    end

    def receiver_count_exceeded?
      charitable_aid.receiver_count >= charitable_aid.openings
    end

    def charitable_aid
      @charitable_aid ||= charitable_aid_application.charitable_aid
    end

    def error_no_permissions
      error(
        json: { message: "No permission to update charitable aid application" },
        http_status: :unauthorized
      )
    end

    def error_enough_receivers
      error(
        json: { message: "Enough receivers" },
        http_status: :unprocessable_entity
      )
    end
  end
end
