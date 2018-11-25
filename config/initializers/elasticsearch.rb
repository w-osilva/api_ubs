require 'typhoeus'
require 'typhoeus/adapters/faraday'

$elasticsearch_conf = YAML.load(ERB.new(File.read(Rails.root.join('config/elasticsearch.yml').to_s)).result)[Rails.env]

ENV["ELASTICSEARCH_URL"] ||= $elasticsearch_conf[:url]

ESClient = Elasticsearch::Client.new url: $elasticsearch_conf[:url], log: Rails.env.development?
Elasticsearch::Model.client = ESClient
