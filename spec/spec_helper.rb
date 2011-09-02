# encoding: utf-8
require 'rubygems'
require "rails/all"
require "logger"
require 'rspec/core'
require "sqlite3"
require "mongoid"   
require "rack/test/uploaded_file"

$: << File.expand_path(File.dirname(__FILE__) + "/../app")
gemfile = File.expand_path('../Gemfile', __FILE__)

begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["ACTIVE_METADATA_ENV"] ||= 'test'
                                                                      
# loading ruby files
require "#{File.dirname(__FILE__)}/../lib/engine.rb"
Dir["spec/support/*.rb"].each {|f| require "support/#{(File.basename(f, File.extname(f)) )}"}
Dir["app/models/*.rb"].each {|f| require "models/#{(File.basename(f, File.extname(f)) )}"}

require 'models/inbox'

ActiveRecord::Base.establish_connection YAML.load_file("config/database.yml")[ENV["RAILS_ENV"]]
ActiveRecord::Base.logger = Logger.new "log/test.log"

Mongoid.load!("config/mongoid.yml")
Mongoid.logger = Logger.new "log/test.log"

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
  end

  config.after(:each) do   
    Document.delete_all
    ActiveMeta.delete_all
    FileUtils.remove_dir File.expand_path('public/system/') if Dir.exist?(File.expand_path('public/system/'))
  end

  config.after(:suite) do  
    # seems that closing the established connection isn't really necessary
  end
end