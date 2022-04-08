# frozen_string_literal: true

module CharitableAids
  class CreateService < BaseService
    def initialize(member, params)
      @member = member
      @params = params
    end

    def call
      charitable_aid = member.organization.charitable_aids.new(params)

      if charitable_aid.save
        success(record: charitable_aid)
      else
        error_invalid_params(charitable_aid)
      end
    end

    private

    attr_reader :member, :params
  end
end
