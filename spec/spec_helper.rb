# encoding: utf-8
require 'rubygems'
require "logger"
require 'rspec/core'
require "sqlite3"
require "active_record"

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["DATABASE_ENV"] ||= 'test'
ENV["ACTIVE_METADATA_ENV"] ||= 'test'
                                                                      
# loading ruby files
Dir["lib/*.rb"].each { |f| require File.basename(f, File.extname(f)) }
Dir["spec/support/*.rb"].each {|f| require "support/#{(File.basename(f, File.extname(f)) )}"}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true


  config.before(:suite) do  
    ActiveRecord::Base.establish_connection YAML.load_file("config/database.yml")[ENV["DATABASE_ENV"]]
    ActiveRecord::Base.logger = Logger.new "log/test.log"
  end

  config.after(:each) do   
    Document.delete_all
    ActiveMetadata::MONGO.collections.each { |coll| coll.drop() }
  end

  config.after(:suite) do  
    # seems that closing the established connection isn't really necessary
  end
end