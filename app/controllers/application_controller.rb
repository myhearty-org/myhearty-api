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

  rescue_from ActiveRecord::RecordInvalid do |exception|
    error_invalid_params(exception.record)
  end

  rescue_from ActiveRecord::RecordNotFound, with: :respond_404

  rescue_from ActionController::UnknownFormat, with: :respond_404

  protected

  def set_csrf_cookie
    return cookies.delete("X-CSRF-Token") unless current_user_or_member

    cookies["X-CSRF-Token"] = form_authenticity_token
  end

  def authenticate_organization_admin!
    return head :unauthorized unless authenticate_member! && current_member.admin?
  end

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

  def render_error(json, status)
    if json
      render json: json, status: status
    else
      head status
    end
  end
end
