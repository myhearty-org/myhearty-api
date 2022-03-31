# frozen_string_literal: true

module Members
  class RegistrationsController < Devise::RegistrationsController
    skip_forgery_protection only: %i[create]

    def create
      super do |member|
        @member = member
      end
    end
  end
end
