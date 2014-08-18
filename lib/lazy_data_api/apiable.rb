module LazyDataApi
  module Apiable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def lazy_data
        has_one :lazy_data_api_relation, as: :apiable
        delegate :api_id, to: :lazy_data_api_relation
      end

      def apiable?
        true
      end
    end
  end
end

ActiveRecord::Base.send :include, LazyDataApi::Apiable
