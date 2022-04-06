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
          Rails.application.credentials.stripe.signing_secret[0]
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request and return
      end

      case event.type
      when "account.updated"
        account_updated(event)
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
  end
end
