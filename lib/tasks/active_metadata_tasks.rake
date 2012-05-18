namespace :active_metadata do
  namespace :ci do
    ENV['COVERAGE'] = 'on'
    ENV['JCI'] = 'on'
    ENV['RAILS_ENV'] ||= 'test'

    task :migrate do
      Rake::Task["db:migrate"].invoke
    end

    task :rspec do
      Rake::Task["ci:setup:rspec"].invoke
      Rake::Task["spec"].invoke
    end

    task :cucumber do
      ENV["CUCUMBER_OPTS"] = "--format junit --out features/reports --format html --out features/reports/cucumber.ht"
      Rake::Task["app:cucumber"].invoke
    end
  end
end

task "active_metadata:ci" => ["app:active_metadata:ci:migrate", "app:active_metadata:ci:rspec", "app:active_metadata:ci:cucumber"]

namespace :active_metadata do

  desc "Install the active_metadata gem requirements file ***TASK IS ON ALPHA STAGE***"
  task :install do

    FileUtils.cp File.expand_path('../../../config/active_metadata.yml', __FILE__), File.expand_path('config/')
    puts "Installed active_metadata.yml"

    puts "Copying migrations"
    ts = Time.now.utc.strftime('%Y%m%d%H%M%S')
    FileUtils.cp File.expand_path('../../../db/migrate/02_active_metadata_migrations.rb', __FILE__), File.expand_path("db/migrate/#{ts}_active_metadata_migrations.rb")
    puts "run rake db:migrate to complete the gem installation"

  end

end
