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

  gem.add_runtime_dependency('rspec')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('turnip')
  gem.add_development_dependency('pry-doc')

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if gem.respond_to?(:metadata)
    gem.metadata['allowed_push_host'] = 'https://gemstash.simplybusiness.io/private'
  else
    raise 'RubyGems 2.2 or newer is required to protect against public gem pushes.'
  end
end
