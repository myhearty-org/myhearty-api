# frozen_string_literal: true

module Payments
  class CreateService < BaseService
    def initialize(user, fundraising_campaign, donation, stripe_checkout_session)
      @user = user
      @fundraising_campaign = fundraising_campaign
      @donation = donation
      @stripe_checkout_session = stripe_checkout_session
    end

    def call
      payment = Payment.new(payment_attributes)
      payment.save
      payment
    end

    private

    attr_reader :user, :fundraising_campaign, :donation, :stripe_checkout_session

    def payment_attributes
      {
        user: user,
        fundraising_campaign: fundraising_campaign,
        donation: donation,
        stripe_checkout_session_id: stripe_checkout_session.id,
        status: "pending"
      }
    end
  end
end
