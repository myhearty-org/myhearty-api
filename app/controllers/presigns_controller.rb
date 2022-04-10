# frozen_string_literal: true

class PresignsController < ApplicationController
  before_action :authenticate_user_or_member!

  def image
    set_rack_response Shrine.presign_response(:cache, request.env)
  end

  private

  def set_rack_response((status, headers, body))
    self.status = status
    self.headers.merge!(headers)
    self.response_body = body
  end
end
