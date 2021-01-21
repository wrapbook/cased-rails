# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cased/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'cased-rails'
  spec.version     = Cased::Rails::VERSION
  spec.authors     = ['Garrett Bjerkhoel']
  spec.email       = ['garrett@cased.com']
  spec.homepage    = 'https://github.com/cased/cased-rails'
  spec.summary     = 'Ruby on Rails SDK/client library for Cased'
  spec.description = 'Ruby on Rails SDK/client library for Cased'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'cased-ruby', '~> 0.3.3'
  spec.add_dependency 'rails', '>= 6.0'

  spec.add_development_dependency 'mocha', '1.11.2'
  spec.add_development_dependency 'pg', '1.2.1'
  spec.add_development_dependency 'rubocop', '0.77.0'
  spec.add_development_dependency 'webmock', '3.8.3'
end
