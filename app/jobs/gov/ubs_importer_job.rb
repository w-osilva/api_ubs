class Gov::UbsImporterJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActiveRecord::Base.connection_pool.with_connection do
      ActiveRecord::Base.transaction do

        prototype = ::Adapters::Ubs.from_csv(data)

        # Todo: make import here
      end
    end
  end
end
