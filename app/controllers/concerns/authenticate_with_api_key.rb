# frozen_string_literal: true

module AuthenticateWithApiKey
  extend ActiveSupport::Concern

  included do
    include ActionController::HttpAuthentication::Token::ControllerMethods
  end

  def authenticate_with_api_key
    authenticate_with_http_token do |token, _options|
      api_key = ApiKey.find_by(token: token)
      return unless api_key

      return unless ActiveSupport::SecurityUtils.secure_compare(api_key.token, token)

      organization_admin = api_key.organization.admins.first
      signed_in_organization_admin = sign_in(organization_admin, scope: :member, store: false)

      @api_request = true

      signed_in_organization_admin
    end
  end

  def api_request?
    api_request == true
  end

  private

  attr_reader :api_request
end
