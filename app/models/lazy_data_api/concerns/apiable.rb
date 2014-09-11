module LazyDataApi
  module Concerns
    module Apiable
      extend ActiveSupport::Concern

      included do
        has_one :lazy_data_api_relation, as: :apiable, class_name: "::LazyDataApi::Relation"
        validates :lazy_data_api_relation, associated: true

        delegate :api_id, :api_id=, to: :lazy_data_api_relation

        after_initialize :build_lazy_data_api_relation, if: "lazy_data_api_relation.blank?"
        after_save :save_api_relation

        scope :without_api_id, -> {
          left_join = "LEFT JOIN #{LazyDataApi::Relation.table_name} " \
                          "ON #{LazyDataApi::Relation.table_name}.apiable_id = #{self.table_name}.id " \
                          "AND #{LazyDataApi::Relation.table_name}.apiable_type = '#{self.name}'"
          joins(left_join).where(lazy_data_api_relations: {api_id: nil})
        }
      end

      module ClassMethods
        def apiable?; true; end

        def find_for_api api_id
          joins(:lazy_data_api_relation)
          .where(lazy_data_api_relations: { api_id: api_id })
          .first
        end

        def create_api_ids
          self.without_api_id.each do |apiable|
            apiable.create_lazy_data_api_relation if apiable.lazy_data_api_relation.blank?
          end
        end

        def create_api_resource attributes = {}, server_host = nil
          create attributes
        end
      end

      def initialize attributes = {}, options = {}
        super
        build_lazy_data_api_relation if lazy_data_api_relation.blank?
        lazy_data_api_relation.assign_attributes(api_id: attributes["api_id"]) if attributes && attributes["api_id"]
      end

      def apiable?; true; end

      def save_api_relation
        lazy_data_api_relation.save if lazy_data_api_relation.changed?
      end

      def to_api
        as_json methods: :api_id, except: [:id, :created_at, :updated_at]
      end

      def api_servers
        self.class.api_options.api_servers
      end
    end
  end
end
