# encoding: utf-8
require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["ACTIVEMETADATA_ENV"] ||= 'test'

Dir["lib/*.rb", "spec/support/*.rb"].each { |f| require File.basename(f, File.extname(f)) }

require 'rspec/core'
include ActiveMetadata
          
def read_resource(filename)
  IO.read("spec/resources/#{filename}")  
end

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

  # config.before(:suite) do  
  # end
  # 
  # config.after(:suite) do   
  # end

end