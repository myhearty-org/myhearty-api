# frozen_string_literal: true

class ServiceResponse
  def self.success(record: nil, json: nil, http_status: :ok)
    new(status: :success, record: record, json: json, http_status: http_status)
  end

  def self.error(record: nil, json: nil, http_status: :unprocessable_entity)
    new(status: :error, record: record, json: json, http_status: http_status)
  end

  attr_reader :status, :record, :json, :http_status

  def initialize(status:, record: nil, json: nil, http_status: nil)
    @status = status
    @record = record
    @json = json
    @http_status = http_status
  end

  def success?
    status == :success
  end

  def error?
    status == :error
  end
end
