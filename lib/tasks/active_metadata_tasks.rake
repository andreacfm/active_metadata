require 'rspec/core/rake_task'
require 'cucumber/rake/task'

begin
  require 'ci/reporter/rake/rspec'
  require 'ci/reporter/rake/cucumber'

  namespace :ci do
    ENV['COVERAGE'] = 'on'
    ENV['RAILS_ENV'] = 'test'

    namespace :setup do

      @reports_dir = ENV['CI_REPORTS'] || 'features/reports'

      task :ci_cucumber_report_cleanup do
        rm_rf @reports_dir
      end

      task :ci_cucumber => :ci_cucumber_report_cleanup do
        ENV["CUCUMBER_OPTS"] = "--format CI::Reporter::Cucumber --format junit --out #{@reports_dir}"
      end

    end

    task "spec" => ["ci:setup:rspec", "^spec"]
    task "ci_cucumber" => ["ci:setup:ci_cucumber", "^cucumber"]

  end

  task "ci" => ["db:migrate", "ci:spec", "ci:ci_cucumber"]
rescue LoadError
  # ci_reporter isn't here for some reason
end

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
