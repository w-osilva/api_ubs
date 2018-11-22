require 'csv'
require_relative 'ubs_indexer_job'

class UbsCsvImportJob < ApplicationJob
  queue_as :critical

  retry_on(Exception, wait: 30.seconds, attempts: 3, queue: :low)

  rescue_from(Exception) do |exception|
    log = ::Log.new(Rails.root.join('log/ubs_csv_import_err.log'))
    log.write_exception(exception, title: "[#{Time.now}]", backtrace: false)
  end

  FILE = Rails.root.join('tmp/ubs.csv').to_s.freeze

  def perform
    write_file

    collection = []
    CSV.foreach(FILE, headers: true) do |row|
      data = ::Adapters::Ubs.from_csv(row.to_hash)
      collection << ::Ubs.new(data)
    end

    ::Ubs.transaction do
      ::Ubs.bulk_import(collection, validate: true, validate_uniqueness: false, on_duplicate_key_update: [:phone, :scores, :geocode])
      ::UbsIndexerJob.perform_later
    end
  end

  def write_file
    api = ::Gov::Data.new
    response = api.ubs_get_csv
    content = response.body
    File.open(FILE, 'wb') do |f|
      f.puts content
      f.close
    end
  end

end
