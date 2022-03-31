# frozen_string_literal: true

module Members
  class UnlocksController < Devise::UnlocksController
    skip_forgery_protection only: %i[show create]
  end
end
