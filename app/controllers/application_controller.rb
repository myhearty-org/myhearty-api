# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception, prepend: true

  after_action :set_csrf_cookie

  respond_to :json

  protected

  def set_csrf_cookie
    return cookies.delete("X-CSRF-Token") unless current_user_or_member

    cookies["X-CSRF-Token"] = form_authenticity_token
  end
end
