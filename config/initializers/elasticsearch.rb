require 'typhoeus'
require 'typhoeus/adapters/faraday'

ENV["ELASTICSEARCH_URL"] ||= $elasticsearch_conf[:url]
client = Elasticsearch::Client.new url: $elasticsearch_conf[:url], log: !Rails.env.production?
Elasticsearch::Model.client = client
