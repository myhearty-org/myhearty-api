# frozen_string_literal: true

module Api
  module V0
    class FundraisingCampaignsController < ApiController
      before_action :authenticate_member!, only: %i[create update]
      before_action :authenticate_user!, only: %i[donate]

      def index
        if params.key?(:organization_id)
          organization = Organization.find(params[:organization_id])
          @fundraising_campaigns = organization.fundraising_campaigns
        else
          @fundraising_campaigns = FundraisingCampaign.all
        end
      end

      def show
        @fundraising_campaign = FundraisingCampaign.find(params[:id])
      end

      def create
        @organization = Organization.find(params[:organization_id])
        result = FundraisingCampaigns::CreateService.call(current_member, @organization, fundraising_campaign_params)
        @fundraising_campaign = result.record

        if result.success?
          render :show, status: :created
        else
          render_error(result.json, result.http_status)
        end
      end

      def update
        @fundraising_campaign = FundraisingCampaign.find(params[:id])
        result = FundraisingCampaigns::UpdateService.call(current_member, @fundraising_campaign, fundraising_campaign_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
        end
      end

      def donate
        fundraising_campaign = FundraisingCampaign.find(params[:id])

        result = Donations::CreateService.call(current_user, fundraising_campaign, params[:amount])
        donation = result.record

        return render_error(result.json, result.http_status) unless result.success?

        stripe_checkout_session = create_stripe_checkout_session(current_user, fundraising_campaign, donation)

        Payments::CreateService.call(current_user, fundraising_campaign, donation, stripe_checkout_session)

        redirect_to stripe_checkout_session.url, allow_other_host: true
      end

      private

      def fundraising_campaign_params
        params.require(:fundraising_campaign).permit(fundraising_campaign_params_attributes)
      end

      def fundraising_campaign_params_attributes
        %i[
          name
          target_amount
          location
          about_campaign
          main_image
          youtube_url
          start_datetime
          end_datetime
          published
        ]
      end

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
end
