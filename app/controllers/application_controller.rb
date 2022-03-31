# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception, prepend: true

  respond_to :json
end
