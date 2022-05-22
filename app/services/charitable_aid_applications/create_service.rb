# frozen_string_literal: true

module CharitableAidApplications
  class CreateService < BaseService
    def initialize(receiver, charitable_aid, params)
      @receiver = receiver
      @charitable_aid = charitable_aid
      @params = params
    end

    def call
      return error_not_published unless charitable_aid.published?

      return error_application_closed if charitable_aid.application_closed?

      return error_user_personal_info_missing if receiver.personal_info_missing?

      @charitable_aid_application = find_charitable_aid_application

      return error_already_exists unless charitable_aid_application.new_record?

      if charitable_aid_application.save
        success(record: charitable_aid_application)
      else
        error_invalid_params(charitable_aid_application)
      end
    end

    private

    attr_reader :receiver, :charitable_aid, :charitable_aid_application, :params

    def find_charitable_aid_application
      receiver.charitable_aid_applications
              .where(charitable_aid: charitable_aid)
              .first_or_initialize(params)
    end

    def error_not_published
      error(
        json: { code: "charitable_aid_not_published" },
        http_status: :unprocessable_entity
      )
    end

    def error_application_closed
      error(
        json: { code: "charitable_aid_application_closed" },
        http_status: :unprocessable_entity
      )
    end

    def error_user_personal_info_missing
      error(
        json: { code: "user_personal_info_missing" },
        http_status: :unprocessable_entity
      )
    end

    def error_already_exists
      error(http_status: :not_modified)
    end
  end
end
