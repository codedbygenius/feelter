Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379/1',
    network_timeout: 10 # Increases wait time from 5 to 10 seconds
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/1',
    network_timeout: 10
  }
end
