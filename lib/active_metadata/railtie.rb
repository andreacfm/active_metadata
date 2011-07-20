require 'rails'
module ActiveMetadata
  class Railtie < Rails::Railtie
    rake_tasks do
      require_relative '../rake/rake.task'
    end
  end
end
