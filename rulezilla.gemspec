$:.push File.expand_path("../lib", __FILE__)
require 'rulezilla/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Peter Wu']
  gem.email         = ['peter.wu@simplybusiness.com']
  gem.description   = %q{Rules DSL}
  gem.summary       = %q{Rules DSL}
  gem.homepage      = %q{https://github.com/simplybusiness/rulezilla}

  gem.files         = `git ls-files`.split($\)
  gem.name          = 'rulezilla'
  gem.require_paths = ['lib']
  gem.version       = Rulezilla::VERSION
  gem.license       = 'MIT'

  gem.add_runtime_dependency('gherkin', '~> 2.5')
  gem.add_runtime_dependency('rspec')
  gem.add_runtime_dependency('turnip')
  gem.add_runtime_dependency('pry')
end
