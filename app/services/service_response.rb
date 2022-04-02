# frozen_string_literal: true

class ServiceResponse
  def self.success(message: nil, http_status: :ok)
    new(status: :success, message: message, http_status: http_status)
  end

  def self.error(message: nil, http_status: nil)
    new(status: :error, message: message, http_status: http_status)
  end

  attr_reader :status, :message, :http_status

  def initialize(status:, message: nil, http_status: nil)
    @status = status
    @message = message
    @http_status = http_status
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end
end
