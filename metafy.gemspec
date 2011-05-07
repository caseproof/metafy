# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "metafy/version"

Gem::Specification.new do |s|
  s.name        = "metafy"
  s.version     = Metafy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["supercleanse"]
  s.email       = ["support@caseproof.com"]
  s.homepage    = "http://blairwilliams.com/rails/metafy"
  s.summary     = %q{Meta Attributes Engine for Rails 3}
  s.description = %q{Metafy is a Gem for Rails 3 and above that makes it possible to easily add dynamic attributes to any ActiveRecord model. These dynamic attributes work just like normal database column attributes and are fully searchable (i.e. You can find records by values contained in these dynamic attributes).}

  s.add_dependency('rails','>= 3.0.3')
  s.license = 'MIT'

  s.rubyforge_project = "metafy"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.require_paths = ["app","config","lib"]
end
