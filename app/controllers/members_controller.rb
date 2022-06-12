# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :authenticate_member!, only: %i[index show]
  before_action :authenticate_organization_admin!, only: %i[create destroy]

  def index
    @members = paginate current_member.organization
                                      .members
                                      .not_admin
                                      .order(created_at: :desc)
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
    organization = current_organization_admin.organization
    result = Members::CreateService.call(organization, member_params)
    @member = result.record

    if result.success?
      render :show, status: :created
    else
      render_error(result.json, result.http_status)
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
