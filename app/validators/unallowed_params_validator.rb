# frozen_string_literal: true

class UnallowedParamsValidator < ActiveModel::Validator
  def initialize(options)
    super

    if options[:unallowed_params].blank?
      raise "Provide the unallowed params options"
    end

    if options[:error_code].blank?
      raise "Provide the error code"
    end
  end

  def validate(record)
    unallowed_params.each do |unallowed_param|
      if record.public_send("#{unallowed_param}_changed?")
        record.errors.add(unallowed_param, error_code)
      end
    end
  end

  private

  def unallowed_params
    options[:unallowed_params]
  end

  def error_code
    options[:error_code]
  end
end
