# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_metadata/version"

Gem::Specification.new do |s|
  s.name        = "active_metadata"
  s.version     = ActiveMetadata::VERSION
  s.authors     = ["Andrea Campolonghi", "Gian Carlo Pace"]
  s.email       = ["acampolonghi@gmail.com", "giancarlo.pace@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Add metadata to fields in an active record model}
  s.description = %q{First implementation will write metadata on mongodb}

  s.rubyforge_project = "active_metadata"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sqlite3-ruby"
  s.add_dependency "rails", "3.0.1"
  s.add_dependency "activerecord", "3.0.1"
  s.add_dependency "mongoid", "~> 2.0"
  s.add_dependency "bson_ext"
  s.add_dependency "mongoid-paperclip"
  s.add_dependency "cucumber"
  s.files         = Dir.glob('{lib,app,config,db}/**/*')
  # s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
