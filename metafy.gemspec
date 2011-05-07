# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "metafy/version"

Gem::Specification.new do |s|
  s.name        = "metafy"
  s.version     = Metafy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Caseproof, LLC"]
  s.email       = ["support@caseproof.com"]
  s.homepage    = "http://caseproof.com"
  s.summary     = %q{Meta Attributes Engine for Rails 3}
  s.description = %q{Metafy makes it possible to easily add dynamic attributes to a model that are fully searchable.}

  s.add_dependency 'rails'

  s.rubyforge_project = "metafy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["app","config","lib"]
end
