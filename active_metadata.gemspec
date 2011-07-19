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

  s.add_development_dependency "rspec"
  s.add_development_dependency "activerecord", "3.0.9"
  s.add_development_dependency "sqlite3-ruby"
  s.add_dependency "mongo"
  s.add_dependency "bson_ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
