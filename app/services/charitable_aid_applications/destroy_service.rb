# frozen_string_literal: true

module CharitableAidApplications
  class DestroyService < BaseService
    def initialize(receiver, charitable_aid)
      @receiver = receiver
      @charitable_aid = charitable_aid
    end

    def call
      @charitable_aid_application = CharitableAidApplication.find_by(receiver: receiver, charitable_aid: charitable_aid)

      return error(http_status: :not_found) unless charitable_aid_application

      return error_application_processed if processing_application?

      charitable_aid_application.delete
      success
    end

    private

    attr_reader :receiver, :charitable_aid, :charitable_aid_application

    def processing_application?
      charitable_aid_application.processed? || charitable_aid.deadline_exceeded?
    end

    def error_application_processed
      error(
        json: { code: "charitable_aid_application_processed" },
        http_status: :unprocessable_entity
      )
    end
  end
end
