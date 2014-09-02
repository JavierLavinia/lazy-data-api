module LazyDataApi
  class Options

    class_attribute :api_servers

    self.api_servers = {}

    def self.server name, url_options
      api_servers[name] = url_options
    end
  end
end
