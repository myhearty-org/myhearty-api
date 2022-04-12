# frozen_string_literal: true

module Deadlinable
  extend ActiveSupport::Concern

  def deadline_exceeded(deadline)
    return Time.current > attribute_was(deadline) if attribute_was(deadline)
  end
end
