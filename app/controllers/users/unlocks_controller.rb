# frozen_string_literal: true

module Users
  class UnlocksController < Devise::UnlocksController
    skip_forgery_protection only: %i[create]
  end
end
