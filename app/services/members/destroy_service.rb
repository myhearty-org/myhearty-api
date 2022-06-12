# frozen_string_literal: true

module Members
  class DestroyService < BaseService
    def initialize(admin, id)
      @admin = admin
      @id = id
    end

    def call
      member = Member.find_by(id: id, organization: admin.organization)

      return error(http_status: :not_found) unless member

      return error_organization_admin_not_deletable if member.admin?

      member.delete
      success
    end

    private

    attr_reader :admin, :id

    def error_organization_admin_not_deletable
      error(
        json: { code: "organization_admin_not_deletable" },
        http_status: :forbidden
      )
    end
  end
end
