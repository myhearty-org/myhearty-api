# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_forgery_protection only: %i[create]

    def create
      super do |user|
        @user = user
      end
    end
  end
end
