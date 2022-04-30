# frozen_string_literal: true

require "typesense"
require "logger"

TypesenseClient = Typesense::Client.new(
  nodes: [
    {
      host: "api.myhearty.my",
      port: 8108,
      protocol: "https"
    }
  ],
  api_key: ENV["TYPESENSE_API_KEY"],
  num_retries: 10,
  healthcheck_interval_seconds: 1,
  retry_interval_seconds: 0.01,
  connection_timeout_seconds: 10,
  logger: Logger.new(STDOUT),
  log_level: Logger::INFO
)
