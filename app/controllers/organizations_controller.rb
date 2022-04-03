# frozen_string_literal: true

class OrganizationsController < ApplicationController
  skip_forgery_protection only: %i[create]

  def create
    organization_params, admin_params = create_organization_params

    @organization = Organizations::CreateService.call(organization_params)

    if @organization.persisted?
      @organization_admin = Members::CreateService.call(admin_params, @organization, admin: true)

      return render :create, status: :created if @organization_admin.persisted?

      error_invalid_params(@organization_admin)
    else
      error_invalid_params(@organization)
    end
  end

  private

  def create_organization_params
    organization_params, admin_params = params.require([:organization, :admin])
    [organization_params.permit(organization_params_attributes), admin_params.permit(admin_params_attributes)]
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
end
