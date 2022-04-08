# frozen_string_literal: true

class OrganizationsController < ApplicationController
  skip_forgery_protection only: %i[create stripe_onboard_refresh]
  before_action :authenticate_organization_admin!, only: %i[update stripe_onboard]

  def create
    organization_params, admin_params = create_organization_params

    result = Organizations::CreateService.call(organization_params)
    @organization = result.record

    return render_error(result.json, result.http_status) unless result.success?

    result = Members::CreateService.call(admin_params, @organization, admin: true)
    @organization_admin = result.record

    return render_error(result.json, result.http_status) unless result.success?

    render :create, status: :created
  end

  def update
    @organization = current_organization_admin.organization
    result = Organizations::UpdateService.call(@organization, organization_params)

    if result.success?
      render :show, status: :ok
    else
      render_error(result.json, result.http_status)
    end
  end

  def stripe_onboard
    organization = current_organization_admin.organization

    stripe_account = create_stripe_account(organization)
    stripe_account_link = create_stripe_account_link(stripe_account.id)

    session[:stripe_account_id] = stripe_account.id
    redirect_to stripe_account_link.url, allow_other_host: true
  end

  def stripe_onboard_refresh
    stripe_account_id = session[:stripe_account_id]

    if stripe_account_id.nil?
      redirect_to "https://dashboard.myhearty.my/stipe-onboard/failed", allow_other_host: true and return
    end

    stripe_account_link = create_stripe_account_link(stripe_account_id)

    redirect_to stripe_account_link.url, allow_other_host: true
  end

  private

  def create_organization_params
    organization_params, admin_params = params.require([:organization, :admin])
    [organization_params.permit(organization_params_attributes), admin_params.permit(admin_params_attributes)]
  end

  def organization_params
    params.require(:organization).permit(organization_params_attributes)
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
      images
      about_us
      programmes_summary
    ]
  end

  def admin_params_attributes
    %i[
      email
      password
    ]
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
      refresh_url: "https://api.myhearty.my/orgs/stripe-onboard/refresh",
      return_url: "https://dashboard.myhearty.my/stipe-onboard/success"
    })
  end
end
