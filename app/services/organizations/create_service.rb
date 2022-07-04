# frozen_string_literal: true

module Organizations
  class CreateService < BaseService
    def initialize(params)
      @params = params
    end

    def call
      organization = Organization.new(params)

      if organization.save
        organization.api_keys.create

        success(record: organization)
      else
        error_invalid_params(organization)
      end
    end

    private

    attr_reader :params
  end
end
