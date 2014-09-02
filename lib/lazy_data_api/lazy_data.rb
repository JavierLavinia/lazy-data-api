require "lazy_data_api/options"

module LazyDataApi
  module LazyData
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def lazy_data api_options_class = LazyDataApi::Options
        include LazyDataApi::Concerns::Apiable
        cattr_accessor :api_options
        self.api_options = api_options_class.new
      end

      def apiable?; false; end
    end

    def apiable?; false; end
  end
end

ActiveRecord::Base.send :include, LazyDataApi::LazyData
