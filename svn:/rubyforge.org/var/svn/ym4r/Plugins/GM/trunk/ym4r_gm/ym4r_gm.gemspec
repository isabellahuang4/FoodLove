$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ym4r_gm/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ym4r_gm"
  s.version     = Ym4rGm::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Ym4rGm."
  s.description = "TODO: Description of Ym4rGm."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
end
