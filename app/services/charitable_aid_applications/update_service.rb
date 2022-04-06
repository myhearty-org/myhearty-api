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

      charitable_aid_application.update(params) ? success : error
    end

    private

    attr_reader :member, :charitable_aid_application, :params

    def organization_member?
      charitable_aid_application.organization.members.include?(member)
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
        message: "No permission to update charitable aid application",
        http_status: :unauthorized
      )
    end

    def error_enough_receivers
      error(
        message: "Enough receivers",
        http_status: :unprocessable_entity
      )
    end
  end
end
