# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json
end
