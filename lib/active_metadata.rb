module ActiveMetadata
  require 'engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'active_metadata/base'
  require 'application_controller'
  require "active_metadata/version"
  require "active_metadata/form_helper"
end