# frozen_string_literal: true

module VolunteerEvents
  class CreateService < BaseService
    def initialize(member, params)
      @member = member
      @params = params
    end

    def call
      volunteer_event = member.organization.volunteer_events.new(params)

      if volunteer_event.save
        success(record: volunteer_event)
      else
        error_invalid_params(volunteer_event)
      end
    end

    private

    attr_reader :member, :params
  end
end
