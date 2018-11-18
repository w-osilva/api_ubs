require 'digest/md5'
require 'csv'
require_relative 'ubs_import_job'
class Gov::UbsCsvImportJob < ApplicationJob
  queue_as :critical

  def perform(in_batch: false, in_background: false)
    file = Rails.root.join('tmp/ubs.csv').to_s.freeze

    File.open(file, 'wb') do |f|
      f.puts ((::Gov::Data.singleton).ubs_get_csv).body
      f.close
    end

    collection = []
    CSV.foreach(file, headers: true) do |row|
      data = ::Adapters::Ubs.from_csv(row.to_hash)
      collection << ((in_batch) ? ::Ubs.new(data) : data)
    end

    if in_batch
      ::Ubs.transaction do
        ::Ubs.bulk_import(collection, validate: true, validate_uniqueness: false, on_duplicate_key_update: [:phone, :scores, :geocode])
        ::Ubs.__elasticsearch__.import
      end
    else
      method = in_background ? :perform_later : :perform_now
      collection.in_groups_of(100, false) do |group|
        ::Ubs.transaction do
          group.each do |data|
            ::Gov::UbsImportJob.send(method, data)
          end
        end
      end
    end
  end

end
