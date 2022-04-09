# frozen_string_literal: true

module Users
  class DonationsController < ApplicationController
    before_action :authenticate_user!

    def index
      @donations = current_user.donations.with_payment
    end
  end
end
