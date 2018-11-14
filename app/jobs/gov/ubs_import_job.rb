class Gov::UbsImportJob < ApplicationJob
  queue_as :default

  retry_on(Exception, wait: 30.seconds, attempts: 3, queue: :low)

  rescue_from(Exception) do |exception|
    log = ::Log.new(Rails.root.join('log/ubs_import_err.log'))
    log.write_exception(exception, title: "[#{Time.now}]", backtrace: false)
  end

  def perform(data)
    ActiveRecord::Base.connection_pool.with_connection do
      ActiveRecord::Base.transaction do
        ubs = ::Ubs.new(data.except(:scores, :geocode))
        ubs.geocode = ::Geocode.find_or_initialize_by(**data[:geocode])
        ubs.scores = ::Score.new(**data[:scores])
        ubs.save!
      end
    end
  end

end