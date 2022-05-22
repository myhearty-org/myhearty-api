# frozen_string_literal: true

module VolunteerEvents
  class DestroyService < BaseService
    def initialize(member, id)
      @member = member
      @id = id
    end

    def call
      volunteer_event = VolunteerEvent.find_by(id: id, organization: member.organization)

      return error(http_status: :not_found) unless volunteer_event

      return error_unallowed_delete if volunteer_event.published?

      volunteer_event.delete
      success
    end

    private

    attr_reader :member, :id

    def error_unallowed_delete
      error(
        json: { code: "published_volunteer_event_not_deletable" },
        http_status: :forbidden
      )
    end
  end
end
