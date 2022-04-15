# frozen_string_literal: true

module VolunteerApplications
  class CreateService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      return error_not_published unless volunteer_event.published?

      return error_application_closed if volunteer_event.application_closed?

      @volunteer_application = find_volunteer_application

      return error_already_exists unless volunteer_application.new_record?

      volunteer_application.save
      success(record: volunteer_application)
    end

    private

    attr_reader :volunteer, :volunteer_event, :volunteer_application

    def find_volunteer_application
      volunteer.volunteer_applications
               .where(volunteer_event: volunteer_event)
               .first_or_initialize
    end

    def error_not_published
      error(
        json: { message: "Not published" },
        http_status: :unprocessable_entity
      )
    end

    def error_application_closed
      error(
        json: { message: "Application closed" },
        http_status: :unprocessable_entity
      )
    end

    def error_already_exists
      error(http_status: :not_modified)
    end
  end
end
