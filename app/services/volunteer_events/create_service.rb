# frozen_string_literal: true

module VolunteerEvents
  class CreateService < BaseService
    def initialize(member, organization, params)
      @member = member
      @organization = organization
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      volunteer_event = organization.volunteer_events.new(params)
      volunteer_event.save ? success(record: volunteer_event) : error(record: volunteer_event)
    end

    private

    attr_reader :member, :organization, :params

    def organization_member?
      organization.members.include?(member)
    end

    def error_no_permissions
      error(
        message: "No permission to create volunteer event",
        http_status: :unauthorized
      )
    end
  end
end