# frozen_string_literal: true

module Users
  class ProfilesController < ApplicationController
    before_action :authenticate_user!

    def update
      @user = current_user
      result = Users::UpdateService.call(current_user, user_params)

      if result.success?
        render :show, status: :ok
      else
        render_error(result.json, result.http_status)
      end
    end

    private

    def user_params
      params.require(:profile).permit(user_params_attributes)
    end

    def user_params_attributes
      %i[
        name
        contact_no
        address
        birth_date
        gender
      ]
    end
  end
end
