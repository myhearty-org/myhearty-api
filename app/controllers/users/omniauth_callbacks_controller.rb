# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    Identity::PROVIDERS.each do |provider|
      define_method(provider) do
        callback_for(provider)
      end
    end

    private

    def callback_for(provider)
      if current_user
        link_oauth_identity_flow(provider)
      else
        sign_in_user_flow(provider)
      end
    end

    def link_oauth_identity_flow(provider)
      result = Oauth::LinkIdentityService.call(current_user, auth_hash)

      case result[:status]
      when :identity_exists
        head :ok
      when :identity_linked
        head :created
      when :identity_failure
        clean_up_omniauth_session(provider)

        render json: { message: result[:errors] }, status: :unprocessable_entity
      end
    end

    def sign_in_user_flow(provider)
      user = Oauth::FindUserService.call(current_user, auth_hash)

      if user
        sign_in(user, event: :authentication)

        head :ok
      else
        clean_up_omniauth_session(provider)

        render json: { message: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    def clean_up_omniauth_session(provider)
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
    end

    def auth_hash
      @auth_hash ||= request.env["omniauth.auth"]
    end
  end
end
