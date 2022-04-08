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

      if charitable_aid.update(params)
        success
      else
        error_invalid_params(charitable_aid)
      end
    end

    private

    attr_reader :member, :charitable_aid, :params

    def organization_member?
      charitable_aid.organization.members.include?(member)
    end

    def error_no_permissions
      error(
        json: { message: "No permission to update charitable aid" },
        http_status: :unauthorized
      )
    end
  end
end
