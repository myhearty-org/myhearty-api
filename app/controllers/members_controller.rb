# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :authenticate_member!, only: %i[index show]
  before_action :authenticate_organization_admin!, only: %i[create destroy]

  def index
    @members = current_member.organization.members
  end

  def show
    @member = Member.find_by(id: params[:id], organization: current_member.organization)

    if @member
      render :show, status: :ok
    else
      head :not_found
    end
  end

  def create
    organization = current_member.organization
    @member = Members::CreateService.call(member_params, organization)

    if @member.persisted?
      render :show, status: :ok
    else
      error_invalid_params(@member)
    end
  end

  def destroy
    result = Members::DestroyService.call(current_organization_admin, params[:id])

    if result.success?
      head :no_content
    else
      render_error(result.json, result.http_status)
    end
  end

  private

  def member_params
    params.require(:member).permit(member_params_attributes)
  end

  def member_params_attributes
    %i[
      email
      password
    ]
  end
end
