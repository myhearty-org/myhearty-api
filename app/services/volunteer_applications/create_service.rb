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

    def success_already_exists
      success(
        record: volunteer_application,
        http_status: :not_modified
      )
    end
  end
end
