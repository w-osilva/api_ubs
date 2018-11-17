class IndexerJob < ApplicationJob
  queue_as :elasticsearch

  def perform(model_name, operation, record_id)
    model = (model_name.constantize)
    record = model.find(record_id)

    case operation.to_s
    when /index/ then record.__elasticsearch__.index_document
    when /update/ then record.__elasticsearch__.update_document
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end

    logger.debug ActiveSupport::LogSubscriber.new.send(:color, "Indexed! #{model_name} {id: #{record_id}}", :yellow, true)
  end

end
