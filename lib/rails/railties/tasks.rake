namespace :active_metadata do

  desc "Install the active_metadata gem requirements file ***TASK IS ON ALPHA STAGE***"
  task :install do

    FileUtils.cp File.expand_path('../../../config/active_metadata.yml',__FILE__), File.expand_path('config/')
    puts "Installed active_metadata.yml"

    puts "Copying migrations"
    ts = Time.now.utc.strftime('%Y%m%d%H%M%S')
    FileUtils.cp File.expand_path('../../../db/migrate/02_active_metadata_migrations.rb',__FILE__), File.expand_path("db/migrate/#{ts}_active_metadata_migrations.rb")
    puts "run rake db:migrate to complete the gem installation"    

  end

end
