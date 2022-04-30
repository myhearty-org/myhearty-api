sidekiq_config = {
  url: "redis://redis:6379/0",
  id: "Sidekiq-server-PID-#{::Process.pid}",
  password: ENV["REDIS_PASSWORD"]
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
