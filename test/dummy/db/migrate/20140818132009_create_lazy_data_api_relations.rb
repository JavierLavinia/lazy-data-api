class CreateLazyDataApiRelations < ActiveRecord::Migration
  def self.up
    create_table :lazy_data_api_relations, id: false do |t|
      t.string :api_id
      t.integer :apiable_id
      t.string  :apiable_type
    end
    add_index :lazy_data_api_relations, :api_id
    add_index :lazy_data_api_relations, [:apiable_id,:apiable_type], name: :lazy_data_api_relation_resource_index
    add_index :lazy_data_api_relations, [:api_id,:apiable_id,:apiable_type], name: :lazy_data_api_relation_full_index
  end

  def self.down
    drop_table :lazy_data_api_relations
  end
end
