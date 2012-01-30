# encoding: utf-8
require 'rubygems'
require "rails/all"
require "logger"
require 'rspec/core'
require "sqlite3"
require "rack/test/uploaded_file"
require 'active_support/cache'
require 'paperclip'

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

ActiveRecord::Base.establish_connection YAML.load_file("config/database.yml")[ENV["RAILS_ENV"]]
ActiveRecord::Base.logger = Logger.new "log/test.log"
Rails.logger = ActiveRecord::Base.logger
Paperclip.logger = Rails.logger

RAILS_CACHE = ActiveSupport::Cache::MemoryStore.new
                                                                      
# loading ruby files
require "#{File.dirname(__FILE__)}/../lib/engine.rb"
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


  config.before(:each) do
    Document.delete_all
    Note.delete_all
    Watcher.delete_all
    Attachment.delete_all
    History.delete_all    
    FileUtils.remove_dir File.expand_path('public/system/') if Dir.exist?(File.expand_path('public/system/'))       
  end

  config.after(:suite) do  
    # seems that closing the established connection isn't really necessary
  end
end

def test_pdf name='pdf_test'
  doc = File.expand_path("../support/#{name}.pdf", __FILE__)
  Rack::Test::UploadedFile.new(doc, "application/pdf")
end