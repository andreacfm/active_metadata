require 'rails'
class Railtie < Rails::Railtie
  rake_tasks do
    require_relative '../rake/task.rb'
  end
end
