# frozen_string_literal: true

module CharitableAidApplications
  class CreateService < BaseService
    def initialize(receiver, charitable_aid)
      @receiver = receiver
      @charitable_aid = charitable_aid
    end

    def call
      charitable_aid_application = find_charitable_aid_application

      return success(record: charitable_aid_application, http_status: :not_modified) unless charitable_aid_application.new_record?

      charitable_aid_application.save
      success(record: charitable_aid_application, http_status: :created)
    end

    private

    attr_reader :receiver, :charitable_aid

    def find_charitable_aid_application
      receiver.charitable_aid_applications
              .where(charitable_aid: charitable_aid)
              .first_or_initialize
    end
  end
end
