# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = proc { URL.url }
