# CURRENT FILE :: lib/lazy_data_api.rb
# Requires
require "active_support/dependencies"

module LazyDataApi

  # Our host application root path
  # We set this when the engine is initialized
  mattr_accessor :app_root

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end

# Require our engine
require "lazy_data_api/engine"
