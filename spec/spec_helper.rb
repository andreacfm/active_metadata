# encoding: utf-8
require 'rubygems'
require "rails/all"
require "logger"
require 'rspec/core'
require 'cucumber'
require 'cucumber/rake/task'
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

ENV["RAILS_ENV"] ||= 'test'
ENV["ACTIVE_METADATA_ENV"] ||= 'test'

ActiveRecord::Base.establish_connection YAML.load_file("config/database.yml")[ENV["RAILS_ENV"]]
ActiveRecord::Base.logger = Logger.new "log/test.log"
Rails.logger = ActiveRecord::Base.logger  

#load the config
conf = YAML.load_file('config/active_metadata.yml')[Rails.env]
is_mongo = conf['persists_with'] == 'mongoid'

if is_mongo 
  Mongoid.load!("config/mongoid.yml")
end
                                                                      
# loading ruby files
require "#{File.dirname(__FILE__)}/../lib/engine.rb"
Dir["spec/support/*.rb"].each {|f| require "support/#{(File.basename(f, File.extname(f)) )}"}
Dir["app/models/*.rb"].each {|f| require "models/#{(File.basename(f, File.extname(f)) )}"}

require 'models/inbox'


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
    if is_mongo 
      ActiveMeta.create_indexes()
      Label.create_indexes()
      Note.create_indexes();
    end  
  end

  config.before(:each) do
    Document.delete_all
    Note.delete_all
    Watcher.delete_all
    Attachment.delete_all
    History.delete_all    
    if is_mongo 
      ActiveMeta.delete_all
      Label.delete_all
    end  
    FileUtils.remove_dir File.expand_path('public/system/') if Dir.exist?(File.expand_path('public/system/'))       
  end

  config.after(:suite) do  
    # seems that closing the established connection isn't really necessary
  end
end