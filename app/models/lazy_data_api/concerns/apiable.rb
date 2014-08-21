module LazyDataApi
  module Concerns
    module Apiable
      extend ActiveSupport::Concern

      included do
        has_one :lazy_data_api_relation, as: :apiable, class_name: "::LazyDataApi::Relation"
        validates :lazy_data_api_relation, associated: true

        delegate :api_id, :api_id=, to: :lazy_data_api_relation

        after_initialize :initialize_api_relation
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

      def apiable?; true; end

      def initialize_api_relation
        build_lazy_data_api_relation if lazy_data_api_relation.blank?
      end

      def save_api_relation
        lazy_data_api_relation.save if lazy_data_api_relation.changed?
      end
    end
  end
end
