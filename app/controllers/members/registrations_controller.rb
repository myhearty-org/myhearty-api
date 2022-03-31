# frozen_string_literal: true

module Members
  class RegistrationsController < Devise::RegistrationsController
    skip_forgery_protection only: %i[create]
  end
end
