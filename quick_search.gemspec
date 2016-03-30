$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quick_search/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quick_search"
  s.version     = QuickSearch::VERSION
  s.authors     = ["Kevin Beswick"]
  s.email       = ["kdbeswic@ncsu.edu"]
  s.homepage    = "http://search.lib.ncsu.edu"
  s.summary     = "QuickSearch"
  s.description = "QuickSearch"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  #TODO: add the dependenices
  s.add_dependency "kaminari"
  s.add_dependency "nokogiri"
  s.add_dependency "fastimage"
  s.add_dependency "mysql2"
  s.add_dependency "rsolr"
  s.add_dependency "exception_notification"
  s.add_dependency "newrelic_rpm" #required?
  s.add_dependency "modernizr-rails"
  s.add_dependency "therubyracer"


end
