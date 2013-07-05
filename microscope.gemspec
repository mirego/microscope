# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microscope/version'

Gem::Specification.new do |spec|
  spec.name          = 'microscope'
  spec.version       = Microscope::VERSION
  spec.authors       = ["Simon Prévost", "Rémi Prévost"]
  spec.email         = ["sprevost@mirego.com", "rprevost@mirego.com"]
  spec.description   = 'Microscope adds useful scopes targeting ActiveRecord boolean and datetime fields.'
  spec.summary       = 'Microscope adds useful scopes targeting ActiveRecord boolean and datetime fields.'
  spec.homepage      = 'https://github.com/mirego/microscope'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 3.0.0'
  spec.add_dependency 'actionpack', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
