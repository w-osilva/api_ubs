require 'csv'
namespace :ubs do

  desc "Import UBSs from CSV"
  task csv_import: :environment do |_task|
    puts "Importing UBSs from CSV"

    api = Gov::Data.new
    response = api.ubs_get_csv

    file = Rails.root.join('tmp/ubs.csv').to_s
    File.open(file, 'wb') do |f|
      f.puts response.body
      f.close
    end

    CSV.foreach(file, headers: true) do |row|
      Gov::UbsImporterJob.perform_now(row.to_hash)
    end

  end

end
