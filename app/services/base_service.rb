# frozen_string_literal: true

class BaseService
  def self.call(...)
    new(...).call
  end

  def success(message: nil, http_status: nil)
    ServiceResponse.success(message: message, http_status: http_status)
  end

  def error(message: nil, http_status: nil)
    ServiceResponse.error(message: message, http_status: http_status)
  end
end
