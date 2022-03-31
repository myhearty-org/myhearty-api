# frozen_string_literal: true

module Members
  class ConfirmationsController < Devise::ConfirmationsController
    skip_forgery_protection only: %i[show]

    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        respond_with_navigational(resource) do
          redirect_to after_confirmation_path_for(resource_name, resource), allow_other_host: true
        end
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
      end
    end

    def after_confirmation_path_for(_resource_name, _resource)
      "https://dashboard.myhearty.my"
    end
  end
end
