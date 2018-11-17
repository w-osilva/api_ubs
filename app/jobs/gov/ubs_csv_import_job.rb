require 'csv'
require_relative 'ubs_import_job'
class Gov::UbsCsvImportJob < ApplicationJob
  queue_as :critical

  def perform
    api = Gov::Data.new
    response = api.ubs_get_csv

    file = Rails.root.join('tmp/ubs.csv').to_s
    File.open(file, 'wb') do |f|
      f.puts response.body
      f.close
    end

    CSV.foreach(file, headers: true) do |row|
      data = ::Adapters::Ubs.from_csv(row.to_hash)
      unless ::Ubs.exists?(data.except(:scores, :geocode, :phone))
        Gov::UbsImportJob.perform_later(data)
      end
    end
  end

end
