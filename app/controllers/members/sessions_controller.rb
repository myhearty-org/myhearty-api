# frozen_string_literal: true

module Members
  class SessionsController < Devise::SessionsController
    skip_forgery_protection only: %i[create]
  end
end
