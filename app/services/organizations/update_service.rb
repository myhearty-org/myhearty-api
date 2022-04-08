# frozen_string_literal: true

module Organizations
  class UpdateService < BaseService
    def initialize(organization, params)
      @organization = organization
      @params = params
    end

    def call
      if organization.update(params)
        success
      else
        error_invalid_params(organization)
      end
    end

    private

    attr_reader :organization, :params
  end
end
