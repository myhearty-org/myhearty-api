# frozen_string_literal: true

module Members
  class SessionsController < Devise::SessionsController
    skip_forgery_protection only: %i[create]

    def create
      super do |member|
        @member = member
      end
    end
  end
end
