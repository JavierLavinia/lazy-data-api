module LazyDataApi
  module LazyData
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def lazy_data
        include LazyDataApi::Concerns::Apiable
      end

      def apiable?; false; end
    end

    def apiable?; false; end
  end
end

ActiveRecord::Base.send :include, LazyDataApi::LazyData
