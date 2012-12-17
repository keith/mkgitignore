# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mkgitignore/version'

Gem::Specification.new do |gem|
  gem.name          = "mkgitignore"
  gem.version       = Mkgitignore::VERSION
  gem.authors       = ["Keith Smiley"]
  gem.email         = ["keithbsmiley@gmail.com"]
  gem.description   = "Write a gem description}"
  gem.summary       = "Write a gem summary"
  gem.homepage      = "http://fff.com"

  gem.add_runtime_dependency "rest-client", "~> 1.6.6"
  gem.add_runtime_dependency "colored", "~> 1.2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
