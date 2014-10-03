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
          .readonly(false)
          .first
        end

        def create_api_ids
          self.without_api_id.each do |apiable|
            if apiable.lazy_data_api_relation.blank?
              apiable.create_lazy_data_api_relation
            elsif apiable.lazy_data_api_relation.new_record?
              apiable.lazy_data_api_relation.save
            end
          end
        end

        def create_api_resource attributes = {}, server_host = nil
          create attributes
        end
      end

      def update_api_resource attributes = {}, server_host = nil
        update_attributes attributes
      end

      def initialize attributes = {}, options = {}
        super
        build_lazy_data_api_relation if lazy_data_api_relation.blank?
        # Problem with rails version and attributes keys
        api_id = (attributes["api_id"] || attributes[:api_id]) if attributes
        lazy_data_api_relation.assign_attributes(api_id: api_id) if api_id
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

      def url_options
        namespaces = self.class.name.deconstantize.underscore.gsub('::','/')
        resource_name = self.class.name.demodulize.underscore
        {
          namespaces: (namespaces unless namespaces.blank?),
          resource_name: resource_name,
          api_id: self.api_id
        }
      end

      def server_url_options server_name
        server_url_options = self.api_servers[server_name.to_sym]
        server_url_options.blank? ? {} : server_url_options.merge(self.url_options)
      end
    end
  end
end
