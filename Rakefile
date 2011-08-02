require 'bundler/gem_tasks'
require 'rake/active_record_tasks'  
require 'ci/reporter/rake/rspec'

namespace :ci do
  namespace :setup do
    @reports_dir = ENV['CI_REPORTS'] || 'features/reports'
    task :cucumber_report_cleanup do
      rm_rf @reports_dir
    end

    task :cucumber => :cucumber_report_cleanup do
      extra_opts = "--format junit --out #{@reports_dir}"
      ENV["CUCUMBER_OPTS"] = "#{ENV['CUCUMBER_OPTS']} #{extra_opts}"
    end
  end
end
                                                            