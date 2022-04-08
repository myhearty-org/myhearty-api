# frozen_string_literal: true

class MembersController < ApplicationController
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
end
