# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'tumbler/version'

Gem::Specification.new do |s|
  s.name        = "tumbler"
  s.version     = Tumbler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/tumbler"
  s.description = "Let's make gem development fun and remove all the repetition! Tumbler provides support for common gem management tasks which helps you spend less time dealing with gem releases and more time focusing on your gem functionality!"
  s.summary     = "Common gem generation and management tasks"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "tumbler"

  s.add_dependency "bundler", ">= 1.0.0.rc.3"
  s.add_development_dependency "riot"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end