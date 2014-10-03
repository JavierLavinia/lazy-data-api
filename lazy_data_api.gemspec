# CURRENT FILE :: lazy_data_api.gemspec
require File.expand_path("../lib/lazy_data_api/version", __FILE__)

# Provide a simple gemspec so that you can easily use your
# Enginex project in your Rails apps through Git.
Gem::Specification.new do |s|
  s.name = "lazy_data_api"
  s.version = LazyDataApi::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = [ "Ruben Sierra Gonzalez" ]
  s.homepage = "https://github.com/simplelogica/lazy-data-api"
  s.summary = "lazy-data-api-#{s.version}"
  s.description = "Fetch/send data from/to other applications."

  s.required_rubygems_version = "> 1.3.6"

  s.add_dependency "rails", "~> 3.2.11"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "faker"
  s.add_development_dependency "mocha"
  s.add_development_dependency "fakeweb", ["~> 1.3"]

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_path = 'lib'
end
