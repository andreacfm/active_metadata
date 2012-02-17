namespace :jenkins do :environment

  ENV['COVERAGE'] = 'on'
  ENV["RAILS_ENV"] ||= 'test'

  task :clean_rspec_reports do
    rm_rf "spec/reports"
  end

  task :clean_cucumber_reports do
    rm_rf "features/reports"
  end

  task :clean_reports => ["jenkins:clean_rspec_reports", "jenkins:clean_cucumber_reports"]

  task :migrate do
    sh "bundle exec rake db:migrate RAILS_ENV=#{ENV['RAILS_ENV']} "
  end

  task :rspec => "jenkins:clean_rspec_reports" do
    sh "bundle exec rspec spec --format CI::Reporter::RSpec"
  end

  task :cucumber => "jenkins:clean_cucumber_reports" do
    ENV["CUCUMBER_OPTS"] = "--format CI::Reporter::Cucumber --format junit --out features/reports"
    Rake::Task["app:cucumber"].invoke
  end

end

task :jenkins => ["jenkins:clean_reports", "jenkins:migrate", "jenkins:rspec", "jenkins:cucumber"]


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
