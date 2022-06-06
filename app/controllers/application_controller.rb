# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  devise_group :user_or_member, contains: %i[user member]

  alias_method :current_organization_admin, :current_member

  protect_from_forgery with: :exception, prepend: true

  after_action :set_csrf_cookie

  respond_to :json

  rescue_from ActionController::InvalidAuthenticityToken, with: -> { head :forbidden }

  rescue_from ActionController::ParameterMissing, with: :error_missing_params

  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :error_parsing_json

  rescue_from ActiveRecord::RecordInvalid do |exception|
    error_invalid_params(exception.record)
  end

  rescue_from ActiveRecord::RecordNotFound, with: :respond_404

  rescue_from ActionController::UnknownFormat, with: :respond_404

  protected

  def set_csrf_cookie
    return cookies.delete("X-CSRF-Token", domain: %w[myhearty.my localhost], tld_length: 2) unless current_user_or_member

    cookies["X-CSRF-Token"] = { value: form_authenticity_token, domain: %w[myhearty.my localhost], tld_length: 2, expires: 30.days }
  end

  # rubocop:disable Lint/SafeNavigationConsistency

  def authenticate_organization_admin!
    return error_not_admin unless current_member&.admin? || (authenticate_member! && current_member.admin?)
  end

  def authenticate_charity_member!
    return error_not_charity_member unless current_member&.charity? || (authenticate_member! && current_member.charity?)
  end

  def authenticate_user_or_charity_member!
    authenticate_user_or_member!
    return error_not_charity_member if current_member && !current_member.charity?
  end

  # rubocop:enable Lint/SafeNavigationConsistency

  def respond_404(exception)
    render json: {
      message: exception.message
    }, status: :not_found
  end

  def error_invalid_params(record)
    render json: {
      message: "Validation Failed",
      errors: Validation::ErrorsSerializer.new(record).serialize
    }, status: :unprocessable_entity
  end

  def error_missing_params(exception)
    render json: {
      message: "Missing Parameter(s)",
      error: exception.message
    }, status: :unprocessable_entity
  end

  def error_not_admin
    render json: {
      message: "User doesn't have admin rights",
      code: "not_admin"
    }, status: :forbidden
  end

  def error_not_charity_member
    render json: {
      message: "Organization doesn't have charity rights to manage fundraising campaigns",
      code: "not_charity_member"
    }, status: :forbidden
  end

  def error_parsing_json
    render json: {
      message: "Problems parsing JSON"
    }, status: :bad_request
  end

  def render_error(json, status)
    if json
      render json: json, status: status
    else
      head status
    end
  end
end
