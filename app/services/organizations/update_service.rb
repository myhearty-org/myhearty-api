# frozen_string_literal: true

module Organizations
  class UpdateService < BaseService
    def initialize(admin, organization, params)
      @admin = admin
      @organization = organization
      @params = params
    end

    def call
      return error_no_permissions unless organization_admin?

      organization.update(params) ? success : error
    end

    private

    attr_reader :admin, :organization, :params

    def organization_admin?
      organization.admins.include?(admin)
    end

    def error_no_permissions
      error(
        json: { message: "Member does not have admin role to update an organization" },
        http_status: :unauthorized
      )
    end
  end
end
