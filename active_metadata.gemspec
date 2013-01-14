$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_metadata/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_metadata"
  s.version     = ActiveMetadata::VERSION
  s.authors     = ["Andrea Campolonghi", "Gian Carlo Pace"]
  s.email       = ["acampolonghi@gmail.com", "giancarlo.pace@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Add metadata to fields in an active record model}
  s.description = %q{First implementation will write metadata on mongodb}

  s.rubyforge_project = "active_metadata"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.2.10"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "rspec_junit_formatter"
  s.add_dependency "paperclip"
  s.add_dependency "mime-types"
end
