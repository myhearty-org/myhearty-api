# frozen_string_literal: true

module VolunteerApplications
  class CreateService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      @volunteer_application = find_volunteer_application

      return success_already_exists unless volunteer_application.new_record?

      return error_application_closed if application_closed?

      volunteer_application.save
      success(record: volunteer_application, http_status: :created)
    end

    private

    attr_reader :volunteer, :volunteer_event, :volunteer_application

    def find_volunteer_application
      volunteer.volunteer_applications
               .where(volunteer_event: volunteer_event)
               .first_or_initialize
    end

    def application_closed?
      deadline_exceeded? || volunteer_count_exceeded?
    end

    def deadline_exceeded?
      Time.current > volunteer_event.application_deadline
    end

    def volunteer_count_exceeded?
      volunteer_event.volunteer_count >= volunteer_event.openings
    end

    def success_already_exists
      success(
        record: volunteer_application,
        http_status: :not_modified
      )
    end

    def error_application_closed
      error(
        message: "Application closed",
        http_status: :unprocessable_entity
      )
    end
  end
end
