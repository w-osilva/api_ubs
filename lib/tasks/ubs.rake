namespace :ubs do

  desc "Import UBS from CSV"
  task csv_import: :environment do |_task|
    puts "Importing UBS from CSV"
    Gov::UbsCsvImportJob.perform_now
  end

end
