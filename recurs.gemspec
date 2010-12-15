# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "recurs/version"

Gem::Specification.new do |s|
  s.name        = "recurs"
  s.version     = Recurs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Caney Martin"]
  s.email       = ["steve@shakewell.co.uk"]
  s.homepage    = "http://rubygems.org/gems/recurs"
  s.summary     = %q{A recurrence generator for ical format}
  s.description = %q{Specifiy you're recurrence pattern in symbols and strings and get an ical format recurrence string}

  s.rubyforge_project = "recurs"
  s.add_dependency('ri_cal', '>= 0.8.7')
  s.add_dependency('actic')

  s.add_development_dependency 'rspec', '~> 2.3.0'
  s.add_development_dependency 'aruba', '~> 0.2.7'
  s.add_development_dependency('rake')
  s.add_development_dependency('cucumber')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
