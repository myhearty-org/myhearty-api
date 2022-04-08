# frozen_string_literal: true

module Organizations
  class UpdateService < BaseService
    def initialize(admin, params)
      @admin = admin
      @params = params
    end

    def call
      organization = admin.organization

      if organization.update(params)
        success(record: organization)
      else
        error_invalid_params(organization)
      end
    end

    private

    attr_reader :admin, :params
  end
end
