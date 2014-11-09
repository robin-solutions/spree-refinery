$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "refinery_spree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "refinery-spree"
  s.version     = RefinerySpree::VERSION
  s.authors     = ["Ben Robbins"]
  s.email       = ["ben.robbins@robinsolutionsllc.com"]
  s.homepage    = "http://github.com/robin-solutions/refinery-spree"
  s.summary     = "Spree 2.4 and Refinery 3 integration"
  s.description = "Spree 2.4 and Refinery 3 integration"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.add_dependency "rails", ">= 4.1.0"
  s.add_dependency "refinerycms", ">= 3.0.0"
  s.add_dependency "spree", ">= 2.3.9"
  s.add_dependency "devise", ">= 3.2.4"

  s.add_development_dependency "sqlite3"
end
