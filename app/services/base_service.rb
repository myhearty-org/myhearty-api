# frozen_string_literal: true

class BaseService
  def self.call(...)
    new(...).call
  end

  def success(record: nil, message: nil, http_status: nil)
    ServiceResponse.success(record: record, message: message, http_status: http_status)
  end

  def error(record: nil, message: nil, http_status: nil)
    ServiceResponse.error(record: record, message: message, http_status: http_status)
  end
end
