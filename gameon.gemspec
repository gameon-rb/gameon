# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gameon/version'

Gem::Specification.new do |spec|
  spec.name          = "gameon"
  spec.version       = Gameon::VERSION
  spec.authors       = ["theotherstupidguy"]
  spec.email         = ["theotherstupidguy@gmail.com"]
  spec.summary       = "gamification framework" 
  spec.description   = "a gamification framework based on mushin" 
  spec.homepage      = "https://github.com/gameon-rb/gameon"
  spec.license       = "MIT"

  spec.files       = ["lib/gameon.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "mushin", "0.0.0.pre2"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
