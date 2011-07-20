require 'rake'
require 'fileutils'

namespace :active_metadata do
  task :install do
    FileUtils.cp File.expand_path('../../templates/mongo.yml',__FILE__), File.expand_path('config/')
    puts "Installed mongo.yml"
  end
end
