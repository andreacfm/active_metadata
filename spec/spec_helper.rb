# encoding: utf-8
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rails/all'
require 'active_metadata'
require 'rack/test/uploaded_file'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

require 'rspec/rails'


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
    ActiveMetadata::Note.delete_all
    ActiveMetadata::Watcher.delete_all
    ActiveMetadata::Attachment.delete_all
    ActiveMetadata::History.delete_all
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