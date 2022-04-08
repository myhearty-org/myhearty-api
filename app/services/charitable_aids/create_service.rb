# frozen_string_literal: true

module CharitableAids
  class CreateService < BaseService
    def initialize(member, organization, params)
      @member = member
      @organization = organization
      @params = params
    end

    def call
      return error_no_permissions unless organization_member?

      charitable_aid = organization.charitable_aids.new(params)
      charitable_aid.save ? success(record: charitable_aid) : error(record: charitable_aid)
    end

    private

    attr_reader :member, :organization, :params

    def organization_member?
      organization.members.include?(member)
    end

    def error_no_permissions
      error(
        json: { message: "No permission to create charitable aid" },
        http_status: :unauthorized
      )
    end
  end
end
