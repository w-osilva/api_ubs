#https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-rails/README.md
require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do

  desc "Create Indexes"
  task create_index: :environment do |_task|
    Ubs.__elasticsearch__.create_index!
  end

end
