# CURRENT FILE :: test/test_helper.rb
# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path("../dummy",  __FILE__)

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'factory_girl_rails'
require 'faker'
require "mocha/test_unit"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Test::Unit
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
