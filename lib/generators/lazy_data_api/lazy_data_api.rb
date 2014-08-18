require 'rails/generators'
require 'rails/generators/active_record'

module PaperTrail
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates (but does not run) a migration to add a api relations table.'

    def create_migration_file
      migration_template 'create_lazy_data_api_relations.rb', 'db/migrate/create_lazy_data_api_relations.rb'
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
