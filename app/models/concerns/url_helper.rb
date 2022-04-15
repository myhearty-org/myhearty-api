# frozen_string_literal: true

module UrlHelper
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    def self.default_url_options
      Rails.application.config.action_controller.default_url_options
    end
  end

  def page_url
    url_for(self)
  end
end
