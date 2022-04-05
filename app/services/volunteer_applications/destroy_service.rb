# frozen_string_literal: true

module VolunteerApplications
  class DestroyService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      volunteer_application = VolunteerApplication.find_by(volunteer: volunteer, volunteer_event: volunteer_event)

      return error unless volunteer_application

      volunteer_application.delete
      success
    end

    private

    attr_reader :volunteer, :volunteer_event
  end
end
