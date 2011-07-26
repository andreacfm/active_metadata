require 'rake'
require 'fileutils'

namespace :active_metadata do
  task :install do
    FileUtils.cp File.expand_path('../../templates/mongo.yml',__FILE__), File.expand_path('config/')
    puts "Installed mongo.yml"
    FileUtils.cp File.expand_path('../../templates/active_metadata.yml',__FILE__), File.expand_path('config/')
    puts "Installed active_metadata.yml"
  end
end
