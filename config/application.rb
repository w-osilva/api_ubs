require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'elasticsearch/rails/instrumentation'

module ApiUbs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Timezone
    #---------------------------------------------------------------
    # config.time_zone = 'Central Time (US & Canada)'
    # config.active_record.default_timezone = :local # Or :utc

    # Encoding
    #---------------------------------------------------------------
    config.encoding = "utf-8"

    # Credentials
    #---------------------------------------------------------------
    # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
    # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
    config.require_master_key = true

    # Redis
    #---------------------------------------------------------------
    $redis_conf = YAML.load(ERB.new(File.read(Rails.root.join('config/redis.yml').to_s)).result)[Rails.env]
    adapter = $redis_conf["adapter"].to_sym
    driver = $redis_conf["driver"].to_sym
    expires_in = $redis_conf["expires_in"].split(".")

    redis_options = { url: $redis_conf["url"], namespace: $redis_conf["namespace"] }
    redis_options[:expires_in] = (expires_in[0].to_i.send(expires_in[1]) )
    redis_options[:driver] = driver if driver.present?

    config.action_controller.perform_caching = true
    config.cache_store = adapter, redis_options

    # Sidekiq
    #---------------------------------------------------------------
    config.active_job.queue_adapter = :sidekiq
    Sidekiq.configure_server {|config| config.redis = { url: $redis_conf["url"], namespace: $redis_conf["namespace"]} }
    Sidekiq.configure_client {|config| config.redis = { url: $redis_conf["url"], namespace: $redis_conf["namespace"]} }

    # Action Cable
    #---------------------------------------------------------------
    config.action_cable.mount_path = '/cable'
    config.action_cable.url = '/cable'
    config.action_cable.allowed_request_origins = [ /http:\/\/localhost.*/ ]

    # Elasticsearch
    #---------------------------------------------------------------
    $elasticsearch_conf = YAML.load(ERB.new(File.read(Rails.root.join('config/elasticsearch.yml').to_s)).result)[Rails.env]
    ENV["ELASTICSEARCH_URL"] ||= $elasticsearch_conf[:url]
  end
end
