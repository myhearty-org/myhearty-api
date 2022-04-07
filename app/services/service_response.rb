# frozen_string_literal: true

class ServiceResponse
  def self.success(record: nil, message: nil, http_status: :ok)
    new(status: :success, record: record, message: message, http_status: http_status)
  end

  def self.error(record: nil, message: nil, http_status: :unprocessable_entity)
    new(status: :error, record: record, message: message, http_status: http_status)
  end

  attr_reader :status, :record, :message, :http_status

  def initialize(status:, record: nil, message: nil, http_status: nil)
    @status = status
    @record = record
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
