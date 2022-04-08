# frozen_string_literal: true

class BaseService
  def self.call(...)
    new(...).call
  end

  def success(record: nil, json: nil, http_status: nil)
    ServiceResponse.success(record: record, json: json, http_status: http_status)
  end

  def error(record: nil, json: nil, http_status: nil)
    ServiceResponse.error(record: record, json: json, http_status: http_status)
  end
end
