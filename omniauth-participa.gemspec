# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'omniauth-participa/version'

Gem::Specification.new do |s|
  s.name          = 'omniauth-participa'
  s.version       = Omniauth::Participa::VERSION
  s.authors       = ['Carles Muiños']
  s.email         = ['carles@adabits.org']

  s.summary       = %q{OmniAuth strategy for Participa}
  s.description   = %q{OmniAuth strategy for Participa}
  s.homepage      = 'https://github.com/adab1ts/omniauth-participa'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '~> 2.3'

  s.add_runtime_dependency 'omniauth', '~> 1.6'
  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.4'

  s.add_development_dependency 'bundler', '~> 1.14'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end
