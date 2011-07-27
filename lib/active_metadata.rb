module ActiveMetadata
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'mongoid'
  require 'active_metadata/base'
  require "active_metadata/railtie" if defined?(Rails)
  require 'application_controller'
  require "active_metadata/version"
end