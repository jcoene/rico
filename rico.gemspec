# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rico/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason Coene"]
  gem.email         = ["jcoene@gmail.com"]
  gem.description   = "Simple data types persisted to Riak"
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/jcoene/rico"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rico"
  gem.require_paths = ["lib"]
  gem.version       = Rico::VERSION

  gem.add_dependency              "riak-client", "~> 1.1"

  gem.add_development_dependency  "rake", "~> 10.0"
  gem.add_development_dependency  "rspec", "~> 2.12"
  gem.add_development_dependency  "guard-rspec", "~> 2.3"
end
