# frozen_string_literal: true

module VolunteerApplications
  class CreateService < BaseService
    def initialize(volunteer, volunteer_event)
      @volunteer = volunteer
      @volunteer_event = volunteer_event
    end

    def call
      volunteer_application = volunteer.volunteer_applications.new(volunteer_event: volunteer_event)
      volunteer_application.save
      volunteer_application
    end

    private

    attr_reader :volunteer, :volunteer_event
  end
end
