# frozen_string_literal: true

require 'English'
$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'rulezilla/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Simply Business']
  gem.email         = ['tech@simplybusiness.co.uk']
  gem.description   = 'Rules DSL'
  gem.summary       = 'Rules DSL'
  gem.homepage      = 'https://github.com/simplybusiness/rulezilla'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.name          = 'rulezilla'
  gem.require_paths = ['lib']
  gem.version       = Rulezilla::VERSION
  gem.license       = 'MIT'
  gem.required_ruby_version = '>= 3.2.0'

  gem.add_dependency('ostruct')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('pry-doc')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('simplycop', '~> 2.23')
  gem.add_development_dependency('turnip')
end
