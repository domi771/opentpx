# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
bin = File.expand_path('../bin', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift(bin) unless $LOAD_PATH.include?(bin)
require 'tpx/version'

Gem::Specification.new do |spec|
  spec.name          = 'tpx'
  spec.version       = TPX::VERSION
  spec.authors       = ['LookingGlass']
  spec.email         = ['support@lgscout.com']
  spec.summary       = %q{Threat Partner Exchange (TPX)}
  spec.description   = %q{An open-source format and tools for exchanging threat intelligence data.  This is a JSON-based format that allows sharing of data between partner organizations.}
  spec.homepage      = 'https://github.com/Lookingglass/tpx'
  spec.license       = %q{The Apache License, Version 2.0. See LICENSE.txt}

  spec.files         = Dir.glob(File.join('lib','**','*')) + %w(LICENSE.txt README.md)
  spec.executables   = ['opentpx_tools']
  spec.test_files    = []
  spec.require_paths = ['lib']

  # group :test
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'timecop'
  # group :development
  spec.add_development_dependency 'yard'

  # from http://rubygems.org
  spec.add_dependency 'bundler'
  spec.add_dependency 'rake'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'oj'
  spec.add_dependency 'json-schema', '>= 2.5.1'
  spec.add_dependency 'deep_merge'
  spec.add_dependency 'gli', '~> 2.13.2'
end
