# frozen_string_literal: true

class OrganizationsController < ApplicationController
  skip_forgery_protection only: %i[create stripe_onboard_refresh]
  before_action :authenticate_charity_member!, only: %i[stripe_onboard]
  before_action :authenticate_organization_admin!, only: %i[stripe_onboard api_key]

  def create
    organization_params, admin_params = create_organization_params

    result = nil

    Organization.transaction do
      result = Organizations::CreateService.call(organization_params)
      @organization = result.record

      return render_error(result.json, result.http_status) unless result.success?

      result = Members::CreateService.call(@organization, admin_params, admin: true)
      @organization_admin = result.record

      raise ActiveRecord::Rollback unless result.success?
    end

    return render_error(result.json, result.http_status) unless result.success?

    render :create, status: :created
  end

  def stripe_onboard
    organization = current_organization_admin.organization

    return error_organization_already_stripe_onboarded if organization.stripe_onboarded?

    stripe_account = create_stripe_account(organization)
    stripe_account_link = create_stripe_account_link(stripe_account.id)

    session[:stripe_account_id] = stripe_account.id
    render json: { stripe_account_link_url: stripe_account_link.url }, status: :created
  end

  def stripe_onboard_refresh
    stripe_account_id = session[:stripe_account_id]

    if stripe_account_id.nil?
      redirect_to "https://dashboard.myhearty.my/stripe-onboard?failed", allow_other_host: true and return
    end

    stripe_account_link = create_stripe_account_link(stripe_account_id)

    redirect_to stripe_account_link.url, allow_other_host: true
  end

  def api_keys
    organization = current_organization_admin.organization
    api_keys = organization.api_keys

    render json: api_keys, status: :ok
  end

  private

  def create_organization_params
    organization_params, admin_params = params.require([:organization, :admin])
    [organization_params.permit(organization_params_attributes).merge!(categories_params),
     admin_params.permit(admin_params_attributes)]
  end

  def organization_params_attributes
    %i[
      name
      location
      email
      contact_no
      website_url
      facebook_url
      youtube_url
      person_in_charge_name
      avatar
      video_url
      image
      about_us
      programmes_summary
      charity
    ]
  end

  def admin_params_attributes
    %i[
      email
      password
    ]
  end

  def categories_params
    params.slice(:categories).permit(categories: [])
  end

  def error_organization_already_stripe_onboarded
    render json: {
      code: "organization_already_stripe_onboarded",
      message: "Organization has already been linked to a Stripe account"
    }, status: :unprocessable_entity
  end

  def create_stripe_account(organization)
    Stripe::Account.create({
      type: "standard",
      country: "MY",
      email: organization.email,
      business_type: "non_profit"
    })
  end

  def create_stripe_account_link(stripe_account_id)
    Stripe::AccountLink.create({
      account: stripe_account_id,
      type: "account_onboarding",
      refresh_url: "https://api.myhearty.my/org/stripe-onboard/refresh",
      return_url: "https://dashboard.myhearty.my/stripe-onboard?success"
    })
  end
end
