namespace :ubs do

  desc "First import from CSV"
  task csv_first_import: :environment do |_task|
    if Ubs.count == 0
      puts "First import from CSV"
      `rake ubs:csv_import_batch`
    end
  end

  desc "Import UBS from CSV (in batch)"
  task :csv_import_batch, [:async] => :environment do |_task, args|
    puts "Importing UBS from CSV (in batch)"
    method = args[:async] ? :perform_later : :perform_now
    UbsCsvImportJob.send(method)
  end

end
