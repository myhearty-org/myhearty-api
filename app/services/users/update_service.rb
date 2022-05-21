# frozen_string_literal: true

module Users
  class UpdateService < BaseService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      if user.update(params)
        success
      else
        error_invalid_params(user)
      end
    end

    private

    attr_reader :user, :params
  end
end
