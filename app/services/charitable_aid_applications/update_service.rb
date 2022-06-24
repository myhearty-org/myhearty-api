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

      return error_receiver_count_exceeded if receiver_count_exceeded?

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

    def receiver_count_exceeded?
      params[:status] == "approved" && charitable_aid.receiver_count_exceeded?
    end

    def charitable_aid
      @charitable_aid ||= charitable_aid_application.charitable_aid
    end

    def error_receiver_count_exceeded
      error(
        json: { code: "receiver_count_exceeded" },
        http_status: :unprocessable_entity
      )
    end
  end
end
