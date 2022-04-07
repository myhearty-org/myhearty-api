# frozen_string_literal: true

module Payments
  class UpdateService < BaseService
    def initialize(stripe_checkout_session, stripe_charge)
      @stripe_checkout_session = stripe_checkout_session
      @stripe_charge = stripe_charge
    end

    def call
      update_payment
      update_fundraising_campaign
    end

    private

    attr_reader :stripe_checkout_session, :stripe_charge

    def update_payment
      payment = Payment.find_by(stripe_checkout_session_id: stripe_checkout_session.id)
      payment_attributes = build_payment_attributes
      payment.update(payment_attributes)
    end

    def build_payment_attributes
      {
        gross_amount: stripe_balance_transaction.amount,
        fee: stripe_balance_transaction.fee,
        net_amount: stripe_balance_transaction.net,
        payment_method: stripe_charge.payment_method_details.type,
        status: stripe_charge.status,
        completed_at: Time.current
      }
    end

    def update_fundraising_campaign
      fundraising_campaign_id = stripe_checkout_session.client_reference_id

      FundraisingCampaign.transaction do
        fundraising_campaign = FundraisingCampaign.find_by(fundraising_campaign_id: fundraising_campaign_id)
        fundraising_campaign.total_raised_amount += stripe_balance_transaction.net
        fundraising_campaign.save
      end
    end

    def stripe_balance_transaction
      @stripe_balance_transaction ||= stripe_charge.balance_transaction
    end
  end
end
