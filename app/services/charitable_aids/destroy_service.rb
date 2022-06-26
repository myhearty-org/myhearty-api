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

      charitable_aid.destroy
      success
    end

    private

    attr_reader :member, :id

    def error_unallowed_delete
      error(
        json: { code: "published_charitable_aid_not_deletable" },
        http_status: :forbidden
      )
    end
  end
end
