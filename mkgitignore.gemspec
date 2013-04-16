# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mkgitignore/version'

Gem::Specification.new do |gem|
  gem.name          = 'mkgitignore'
  gem.version       = Mkgitignore::VERSION
  gem.authors       = Mkgitignore::AUTHOR
  gem.email         = Mkgitignore::EMAIL
  gem.description   = 'Easily creates gitignores from the Github gitignore templates repository'
  gem.summary       = 'Create gitignores from Github\'s templates'
  gem.homepage      = 'https://github.com/Keithbsmiley/mkgitignore'
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'commander',   '4.1.3'
  gem.add_runtime_dependency 'rest-client', '1.6.7'
  gem.add_runtime_dependency 'colored',     '1.2'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
