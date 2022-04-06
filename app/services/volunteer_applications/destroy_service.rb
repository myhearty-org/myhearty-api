# frozen_string_literal: true

module VolunteerApplications
  class DestroyService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      @volunteer_application = VolunteerApplication.find_by(volunteer: volunteer, volunteer_event: volunteer_event)

      return error_not_found unless volunteer_application

      return error_application_processed if processing_application?

      volunteer_application.delete
      success
    end

    private

    attr_reader :volunteer, :volunteer_event, :volunteer_application

    def processing_application?
      application_processed? || deadline_exceeded?
    end

    def application_processed?
      !volunteer_application.pending?
    end

    def deadline_exceeded?
      Time.current > volunteer_event.application_deadline
    end

    def error_not_found
      error(http_status: :not_found)
    end

    def error_application_processed
      error(
        message: "Application processed",
        http_status: :unprocessable_entity
      )
    end
  end
end
