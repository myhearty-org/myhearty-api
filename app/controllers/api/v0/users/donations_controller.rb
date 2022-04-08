# frozen_string_literal: true

module Api
  module V0
    module Users
      class DonationsController < ApiController
        before_action :authenticate_user!

        def index
          @donations = current_user.donations.with_payment
        end
      end
    end
  end
end
