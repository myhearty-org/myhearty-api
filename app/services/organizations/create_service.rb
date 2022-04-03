# frozen_string_literal: true

module Organizations
  class CreateService < BaseService
    def initialize(params)
      @params = params
    end

    def call
      organization = Organization.new(params)
      organization.save
      organization
    end

    private

    attr_reader :params
  end
end
