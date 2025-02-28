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

  gem.add_runtime_dependency('ostruct')
  gem.add_runtime_dependency('rspec')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('pry-doc')
  gem.add_development_dependency('rubocop')
  gem.add_development_dependency('turnip')
end
