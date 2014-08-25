class CreateLazyDataApiRelations < ActiveRecord::Migration
  def self.up
    create_table :lazy_data_api_relations, id: false do |t|
      t.string :api_id
      t.integer :apiable_id
      t.string  :apiable_type
    end
  end

  def self.down
    drop_table :lazy_data_api_relations
  end
end
