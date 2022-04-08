# frozen_string_literal: true

module Members
  class DestroyService < BaseService
    def initialize(admin, member_id)
      @admin = admin
      @member_id = member_id
    end

    def call
      member = Member.find_by(id: member_id, organization: admin.organization)

      return error(http_status: :not_found) unless member

      member.delete
      success
    end

    private

    attr_reader :admin, :member_id
  end
end
