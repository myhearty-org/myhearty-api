# frozen_string_literal: true

module CharitableAidApplications
  class DestroyService < BaseService
    def initialize(receiver, charitable_aid)
      @receiver = receiver
      @charitable_aid = charitable_aid
    end

    def call
      @charitable_aid_application = CharitableAidApplication.find_by(receiver: receiver, charitable_aid: charitable_aid)

      return error_not_found unless charitable_aid_application

      return error_application_processed if processing_application?

      charitable_aid_application.delete
      success
    end

    private

    attr_reader :receiver, :charitable_aid, :charitable_aid_application

    def processing_application?
      application_processed? || deadline_exceeded?
    end

    def application_processed?
      !charitable_aid_application.pending?
    end

    def deadline_exceeded?
      Time.current > charitable_aid.application_deadline
    end

    def error_not_found
      error(http_status: :not_found)
    end

    def error_application_processed
      error(
        json: { message: "Application processed" },
        http_status: :unprocessable_entity
      )
    end
  end
end
