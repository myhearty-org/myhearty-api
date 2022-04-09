# frozen_string_literal: true

module VolunteerApplications
  class UpdateService < BaseService
    def initialize(member, volunteer_application, params)
      @member = member
      @volunteer_application = volunteer_application
      @params = params
    end

    def call
      return error(http_status: :not_found) unless organization_member?

      return error_enough_volunteers if enough_volunteers?

      if volunteer_application.update(params)
        success
      else
        error_invalid_params(volunteer_application)
      end
    end

    private

    attr_reader :member, :volunteer_application, :params

    def organization_member?
      volunteer_application.organization == member.organization
    end

    def enough_volunteers?
      params[:status] == "confirmed" && volunteer_count_exceeded?
    end

    def volunteer_count_exceeded?
      volunteer_event.volunteer_count >= volunteer_event.openings
    end

    def volunteer_event
      @volunteer_event ||= volunteer_application.volunteer_event
    end

    def error_enough_volunteers
      error(
        json: { message: "Enough volunteers" },
        http_status: :unprocessable_entity
      )
    end
  end
end
