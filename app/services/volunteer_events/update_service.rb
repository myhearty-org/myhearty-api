# frozen_string_literal: true

module VolunteerEvents
  class UpdateService < BaseService
    def initialize(member, volunteer_event, params)
      @member = member
      @volunteer_event = volunteer_event
      @params = params
    end

    def call
      return error(http_status: :not_found) unless organization_member?

      if volunteer_event.update(params)
        success
      else
        error_invalid_params(volunteer_event)
      end
    end

    private

    attr_reader :member, :volunteer_event, :params

    def organization_member?
      volunteer_event.organization == member.organization
    end
  end
end
