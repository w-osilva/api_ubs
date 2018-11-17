class Gov::UbsIndexerJob < ApplicationJob
  queue_as :elasticsearch

  def perform(operation, record_id)
    record = ::Ubs.includes(:geocode).find(record_id)

    case operation.to_s
    when /index/ then record.__elasticsearch__.index_document
    when /update/ then record.__elasticsearch__.update_document
    else raise ::ArgumentError, "Unknown operation '#{operation}'"
    end

    logger.debug ::ActiveSupport::LogSubscriber.new.send(:color, "Ibs Indexed (id: #{record_id})", :yellow, true)
  end

end
