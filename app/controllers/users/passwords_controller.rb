# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    skip_forgery_protection only: %i[create]
  end
end
