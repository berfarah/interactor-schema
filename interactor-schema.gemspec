# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interactor/schema/version'

Gem::Specification.new do |spec|
  spec.name          = "interactor-schema"
  spec.version       = Interactor::Schema::VERSION
  spec.authors       = ["Bernardo Farah"]
  spec.email         = ["ber@bernardo.me"]

  spec.summary       = "Enforce a schema with for Interactor Context"
  spec.description   = "Interactor::Schema provides an enforcable Interactor Context"
  spec.homepage      = "https://github.com/berfarah/interactor-schema"
  spec.license       = "MIT"

  spec.files      = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(/^spec/)
  spec.require_paths = ["lib"]

  spec.add_dependency "interactor", "~> 3.1"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "pry", "~> 0.10"
end
