# frozen_string_literal: true

module VolunteerApplications
  class UpdateService < BaseService
    def initialize(member, volunteer_application, params)
      @member = member
      @volunteer_application = volunteer_application
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      volunteer_application.update(params) ? success : error
    end

    private

    attr_reader :member, :volunteer_application, :params

    def organization_member?
      volunteer_application.organization.members.include?(member)
    end

    def error_no_permissions
      error(
        message: "No permission to update volunteer application",
        http_status: :unauthorized
      )
    end
  end
end
