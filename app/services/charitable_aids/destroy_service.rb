# frozen_string_literal: true

module CharitableAids
  class DestroyService < BaseService
    def initialize(member, id)
      @member = member
      @id = id
    end

    def call
      charitable_aid = CharitableAid.find_by(id: id, organization: member.organization)

      return error(http_status: :not_found) unless charitable_aid

      return error_unallowed_delete if charitable_aid.published?

      charitable_aid.delete
      success
    end

    private

    attr_reader :member, :id

    def error_unallowed_delete
      error(
        json: { message: "Not allowed to delete published charitable aid" },
        http_status: :forbidden
      )
    end
  end
end
