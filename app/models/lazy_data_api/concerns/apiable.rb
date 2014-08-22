module LazyDataApi
  module Concerns
    module Apiable
      extend ActiveSupport::Concern

      included do
        has_one :lazy_data_api_relation, as: :apiable, class_name: "::LazyDataApi::Relation"
        validates :lazy_data_api_relation, associated: true

        delegate :api_id, :api_id=, to: :lazy_data_api_relation

        after_save :save_api_relation
      end

      module ClassMethods
        def apiable?; true; end

        def find_for_api apiable_type, api_id
          includes(:lazy_data_api_relation)
          .where(lazy_data_api_relations: { apiable_type: apiable_type, api_id: api_id } )
          .first
        end
      end

      def initialize attributes = {}, options = {}
        super
        build_lazy_data_api_relation(api_id: attributes[:api_id]) if lazy_data_api_relation.blank?
      end

      def apiable?; true; end

      def save_api_relation
        lazy_data_api_relation.save if lazy_data_api_relation.changed?
      end

      def to_api
        as_json methods: :api_id, except: [:id, :created_at, :updated_at]
      end
    end
  end
end
