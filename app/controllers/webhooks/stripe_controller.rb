# frozen_string_literal: true

module Webhooks
  class StripeController < ApplicationController
    skip_forgery_protection

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload,
          sig_header,
          Rails.application.credentials.stripe.webhook_signing_secret
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request and return
      end

      case event.type
      when "account.updated"
        account_updated(event)
      when "checkout.session.completed"
        checkout_session_completed(event)
      else
        head :bad_request
      end
    end

    private

    def account_updated(event)
      stripe_account = event.data.object
      stripe_account_id = event.account

      organization = Organization.find_by(email: stripe_account.email)
      organization&.update(stripe_account_id: stripe_account_id)

      head :ok
    end

    def checkout_session_completed(event)
      stripe_checkout_session = event.data.object
      stripe_account_id = event.account

      stripe_payment_intent_id = stripe_checkout_session.payment_intent
      stripe_payment_intent = Stripe::PaymentIntent.retrieve({ id: stripe_payment_intent_id }, { stripe_account: stripe_account_id })

      stripe_charge_id = stripe_payment_intent.charges.data[0].id
      stripe_charge = Stripe::Charge.retrieve({ id: stripe_charge_id, expand: ["balance_transaction"] }, { stripe_account: stripe_account_id })

      Payments::UpdateService.call(stripe_checkout_session, stripe_charge)

      head :ok
    end
  end
end
