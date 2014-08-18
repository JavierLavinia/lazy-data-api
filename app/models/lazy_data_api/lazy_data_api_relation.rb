module LazyDataApi
  class Relation < ActiveRecord::Base
    self.table_name_prefix = 'lazy_data_api_'
    belongs_to :apiable, :polymorphic => true
  end
end
