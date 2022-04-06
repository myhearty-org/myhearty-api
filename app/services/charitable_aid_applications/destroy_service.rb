# frozen_string_literal: true

module CharitableAidApplications
  class DestroyService < BaseService
    def initialize(receiver, charitable_aid)
      @receiver = receiver
      @charitable_aid = charitable_aid
    end

    def call
      charitable_aid_application = CharitableAidApplication.find_by(receiver: receiver, charitable_aid: charitable_aid)

      return error unless charitable_aid_application

      charitable_aid_application.delete
      success
    end

    private

    attr_reader :receiver, :charitable_aid
  end
end