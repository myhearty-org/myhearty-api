# frozen_string_literal: true

module VolunteerApplications
  class CreateService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      volunteer_application = volunteer.volunteer_applications
                                       .where(volunteer_event: volunteer_event)
                                       .first_or_initialize

      return success(record: volunteer_application, http_status: :not_modified) unless volunteer_application.new_record?

      volunteer_application.save
      success(record: volunteer_application, http_status: :created)
    end

    private

    attr_reader :volunteer, :volunteer_event
  end
end
