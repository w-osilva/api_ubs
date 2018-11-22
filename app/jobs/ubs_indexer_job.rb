require 'csv'
class UbsIndexerJob < ApplicationJob
  queue_as :default

  retry_on(Exception, wait: 30.seconds, attempts: 3, queue: :low)

  rescue_from(Exception) do |exception|
    log = ::Log.new(Rails.root.join('log/ubs_reindex_err.log'))
    log.write_exception(exception, title: "[#{Time.now}]", backtrace: false)
  end

  def perform
    ::Ubs.__elasticsearch__.import
  end

end
