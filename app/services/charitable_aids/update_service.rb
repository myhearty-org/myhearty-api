# frozen_string_literal: true

module CharitableAids
  class UpdateService < BaseService
    def initialize(member, charitable_aid, params)
      @member = member
      @charitable_aid = charitable_aid
      @params = params
    end

    def call
      return error(http_status: :not_found) unless organization_member?

      if charitable_aid.update(params)
        success
      else
        error_invalid_params(charitable_aid)
      end
    end

    private

    attr_reader :member, :charitable_aid, :params

    def organization_member?
      charitable_aid.organization == member.organization
    end
  end
end
