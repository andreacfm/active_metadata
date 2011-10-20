begin
  require 'ci/reporter/rake/rspec'
  require 'ci/reporter/rake/cucumber'

  namespace :ci do

    ENV["DATABASE_ENV"] = 'test'

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
