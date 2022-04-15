# frozen_string_literal: true

module VolunteerApplications
  class DestroyService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      @volunteer_application = VolunteerApplication.find_by(volunteer: volunteer, volunteer_event: volunteer_event)

      return error(http_status: :not_found) unless volunteer_application

      return error_application_processed if processing_application?

      volunteer_application.delete
      success
    end

    private

    attr_reader :volunteer, :volunteer_event, :volunteer_application

    def processing_application?
      volunteer_application.application_processed? || volunteer_event.deadline_exceeded?
    end

    def error_application_processed
      error(
        json: { message: "Application processed" },
        http_status: :unprocessable_entity
      )
    end
  end
end
