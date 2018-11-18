namespace :ubs do

  desc "Import UBS from CSV"
  task csv_import: :environment do |_task|
    puts "Importing UBS from CSV"

    # will send each csv line to be processed in the queue
    Gov::UbsCsvImportJob.perform_now(in_background: true)
  end

  desc "Import UBS from CSV (in batch)"
  task :csv_import_batch, [:in_background] => :environment do |_task, args|
    puts "Importing UBS from CSV (in batch)"

    method = args[:in_background] ? :perform_later : :perform_now
    Gov::UbsCsvImportJob.send(method, in_batch: true)
  end

end
