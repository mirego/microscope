# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microscope/version'

Gem::Specification.new do |spec|
  spec.name          = 'microscope'
  spec.version       = Microscope::VERSION
  spec.authors       = ['Simon Prévost', 'Rémi Prévost', 'Samuel Garneau']
  spec.email         = ['sprevost@mirego.com', 'rprevost@mirego.com', 'sgarneau@mirego.com']
  spec.description   = 'Microscope adds useful scopes targeting ActiveRecord boolean and datetime attributes.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/mirego/microscope'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.1.0'
  spec.add_dependency 'activerecord', '>= 4.1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '0.29'
  spec.add_development_dependency 'phare'
end
