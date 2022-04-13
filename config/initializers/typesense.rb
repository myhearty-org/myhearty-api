# frozen_string_literal: true

require "typesense"
require "logger"

@typesense = Typesense::Client.new(
  nodes: [
    {
      host: "typesense",
      port: 8108,
      protocol: "http"
    }
  ],
  api_key: ENV["TYPESENSE_API_KEY"],
  num_retries: 10,
  healthcheck_interval_seconds: 1,
  retry_interval_seconds: 0.01,
  connection_timeout_seconds: 10,
  logger: Logger.new($stdout),
  log_level: Logger::INFO
)
