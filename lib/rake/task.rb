require 'rake'
require 'fileutils'

namespace :active_metadata do
  task :install do
    #FileUtils.cp File.expand_path('../../templates/mongoid.yml',__FILE__), File.expand_path('config/')
    #puts "Installed mongoid.yml"

    FileUtils.cp File.expand_path('../../templates/active_metadata.yml',__FILE__), File.expand_path('config/')
    puts "Installed active_metadata.yml"

    puts "Copying migrations"
    ts = Time.now.utc.strftime('%Y%m%d%H%M%S')
    FileUtils.cp File.expand_path('../../templates/active_metadata_migrations',__FILE__), File.expand_path("db/migrate/#{ts}_active_metadata_migrations.rb")
    puts "run rake db:migrate to complete the gem installation"    

  end
end
