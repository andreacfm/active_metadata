require 'rspec/core/rake_task'
require 'cucumber/rake/task'

namespace :active_metadata do

  namespace :ci do

    ENV['RAILS_ENV'] ||= 'test'

    RSpec::Core::RakeTask.new(:spec_run) do |t|
      t.rspec_opts = ["-fp", "--format RspecJunitFormatter", "--out spec/reports/rspec.xml"]
    end

    Cucumber::Rake::Task.new(:cucumber_run) do |task|
      format_output = ENV['CUCUMBER_FORMAT'] || 'progress'
      task.cucumber_opts = ["--format #{format_output}", "--format junit", "--out features/reports", "--format html", "--out features/reports/cucumber.html"]
      task.cucumber_opts.push("-p #{ENV['CUCUMBER_PROFILE']}") if ENV['CUCUMBER_PROFILE']
    end

    task :rspec do :environment
      rm_rf "spec/reports"
      Rake::Task["app:active_metadata:ci:spec_run"].invoke
    end

    task :cucumber do :environment
      Rake::Task["app:active_metadata:ci:cucumber_run"].invoke
    end

  end

  task :ci => ["active_metadata:ci:rspec", "active_metadata:ci:cucumber"]

  desc "Install the active_metadata gem requirements file ***TASK IS ON ALPHA STAGE***"
  task :install do

    FileUtils.cp File.expand_path('../../../config/active_metadata.yml', __FILE__), File.expand_path('config/')
    puts "Installed active_metadata.yml"

    puts "Copying migrations"
    ts = Time.now.utc.strftime('%Y%m%d%H%M%S')
    FileUtils.cp File.expand_path('../../../db/migrate/01_active_metadata_migrations.rb', __FILE__), File.expand_path("db/migrate/#{ts}_active_metadata_migrations.rb")
    puts "run rake db:migrate to complete the gem installation"

  end

end
