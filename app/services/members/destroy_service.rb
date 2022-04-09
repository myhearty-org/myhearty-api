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

      member.delete
      success
    end

    private

    attr_reader :admin, :id
  end
end
