# frozen_string_literal: true

module CharitableAids
  class UpdateService < BaseService
    def initialize(member, charitable_aid, params)
      @member = member
      @charitable_aid = charitable_aid
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      charitable_aid.update(params) ? success : error
    end

    private

    attr_reader :member, :charitable_aid, :params

    def organization_member?
      charitable_aid.organization.members.include?(member)
    end

    def error_no_permissions
      error(
        message: "No permission to update charitable aid",
        http_status: :unauthorized
      )
    end
  end
end
