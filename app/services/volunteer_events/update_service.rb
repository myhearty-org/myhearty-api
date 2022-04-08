# frozen_string_literal: true

module VolunteerEvents
  class UpdateService < BaseService
    def initialize(member, volunteer_event, params)
      @member = member
      @volunteer_event = volunteer_event
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      if volunteer_event.update(params)
        success
      else
        error_invalid_params(volunteer_event)
      end
    end

    private

    attr_reader :member, :volunteer_event, :params

    def organization_member?
      volunteer_event.organization.members.include?(member)
    end

    def error_no_permissions
      error(
        json: { message: "No permission to update volunteer event" },
        http_status: :unauthorized
      )
    end
  end
end
