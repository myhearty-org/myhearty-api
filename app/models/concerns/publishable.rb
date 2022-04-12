# frozen_string_literal: true

module Publishable
  extend ActiveSupport::Concern

  def already_published?
    if published?
      !published_changed?
    else
      published_changed?
    end
  end
end
