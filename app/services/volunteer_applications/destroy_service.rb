# frozen_string_literal: true

module VolunteerApplications
  class DestroyService < BaseService
    def initialize(volunteer, volunteer_application)
      @volunteer = volunteer
      @volunteer_application = volunteer_application
    end

    def call
      return error_no_permissions unless volunteer?

      volunteer_application.delete
      success
    end

    private

    attr_reader :volunteer, :volunteer_application

    def volunteer?
      volunteer_application.volunteer == volunteer
    end

    def error_no_permissions
      error(
        message: "No permission to delete volunteer application",
        http_status: :unauthorized
      )
    end
  end
end
