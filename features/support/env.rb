ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../../spec/dummy/config/environment.rb",  __FILE__)
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"

require 'cucumber/rails'
require_relative "../../spec/support/migrations"

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../../')


Before do
  TestDb.up
  Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }
end

After do
  [Document, Section, Chapter, User, ActiveMetadata::Note,
   ActiveMetadata::Watcher, ActiveMetadata::Attachment, ActiveMetadata::History].each do |i|
    i.delete_all
  end
  FileUtils.remove_dir File.expand_path('public/system/') if Dir.exist?(File.expand_path('public/system/'))
  Rails.cache.clear
end

at_exit do
  TestDb.down
end