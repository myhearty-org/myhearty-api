# frozen_string_literal: true

module CharitableAidApplications
  class UpdateService < BaseService
    def initialize(member, charitable_aid_application, params)
      @member = member
      @charitable_aid_application = charitable_aid_application
      @params = params
    end

    def call
      return error(http_status: :not_found) unless organization_member?

      return error_enough_receivers if enough_receivers?

      if charitable_aid_application.update(params)
        success
      else
        error_invalid_params(charitable_aid_application)
      end
    end

    private

    attr_reader :member, :charitable_aid_application, :params

    def organization_member?
      charitable_aid_application.organization == member.organization
    end

    def enough_receivers?
      params[:status] == "approved" && charitable_aid.receiver_count_exceeded?
    end

    def charitable_aid
      @charitable_aid ||= charitable_aid_application.charitable_aid
    end

    def error_enough_receivers
      error(
        json: { message: "Enough receivers" },
        http_status: :unprocessable_entity
      )
    end
  end
end
