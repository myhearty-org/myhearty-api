# frozen_string_literal: true

module Users
  class DonationsController < ApplicationController
    before_action :authenticate_user!

    def index
      @donations = paginate current_user.donations
                                        .with_payment
                                        .includes(:fundraising_campaign)
                                        .order(created_at: :desc)
    end

    def donate
      fundraising_campaign = FundraisingCampaign.find(params[:id])
      result = Donations::CreateService.call(current_user, fundraising_campaign, params[:amount])
      donation = result.record

      return render_error(result.json, result.http_status) unless result.success?

      stripe_checkout_session = create_stripe_checkout_session(current_user, fundraising_campaign, donation)
      Payments::CreateService.call(current_user, fundraising_campaign, donation, stripe_checkout_session)

      render json: { stripe_checkout_url: stripe_checkout_session.url }, status: :created
    end

    private

    def create_stripe_checkout_session(donor, fundraising_campaign, donation)
      Stripe::Checkout::Session.create({
        line_items: [{
          price_data: {
            currency: "myr",
            unit_amount: donation.amount,
            product: fundraising_campaign.fundraising_campaign_id
          },
          quantity: 1
        }],
        mode: "payment",
        payment_method_types: ["alipay", "card", "fpx", "grabpay"],
        submit_type: "donate",
        customer_email: donor.email,
        client_reference_id: fundraising_campaign.fundraising_campaign_id,
        success_url: "https://myhearty.my/campaigns/#{fundraising_campaign.id}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "https://myhearty.my/campaigns/#{fundraising_campaign.id}?cancel=true"
      }, { stripe_account: fundraising_campaign.organization.stripe_account_id })
    end
  end
end
