require File.expand_path('../lib/mondo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_runtime_dependency 'oauth2', '~> 1.0'
  gem.add_runtime_dependency 'money'
  gem.add_runtime_dependency 'multi_json', '~> 1.10'

  gem.add_development_dependency 'rspec', '~> 2.13'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'activesupport', '~> 3.2'
  gem.add_development_dependency 'rake', '~> 10.3'

  gem.authors = ['Tom Blomfield']
  gem.description = %q{A Ruby wrapper for the Mondo API}
  gem.email = ['engineering@getmondo.co.uk']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/mondough/mondo-ruby'
  gem.name = 'mondo'
  gem.require_paths = ['lib']
  gem.summary = %q{Ruby wrapper for the Mondo API}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Mondo::VERSION.dup
  gem.licenses = ['MIT']
end
