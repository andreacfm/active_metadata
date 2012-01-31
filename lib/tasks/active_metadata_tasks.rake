require 'rspec/core/rake_task'
require 'cucumber/rake/task'

begin
  require 'ci/reporter/rake/rspec'
  require 'ci/reporter/rake/cucumber'

  namespace :ci do :environment

    namespace :setup do

      @reports_dir = ENV['CI_REPORTS'] || 'features/reports'

      task :cucumber_report_cleanup do
        rm_rf @reports_dir
      end

      task :cucumber => :cucumber_report_cleanup do
        extra_opts = "--format junit --out #{@reports_dir}"
        ENV["CUCUMBER_OPTS"] = "features/ #{ENV['CUCUMBER_OPTS']} #{extra_opts}"
      end

    end

    task "spec" => ["rspec_run"]
    task "cucumber" => ["cucumber_run"]

  end

  task "ci" => ["db:migrate", "ci:spec", "ci:cucumber"]
rescue LoadError
  # ci_reporter isn't here for some reason
end

RSpec::Core::RakeTask.new(:rspec_run => ["ci:setup:rspec"]) do |t|
  t.pattern = '**/*_spec.rb'
end

Cucumber::Rake::Task.new(:cucumber_run => ["ci:setup:cucumber"])


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
