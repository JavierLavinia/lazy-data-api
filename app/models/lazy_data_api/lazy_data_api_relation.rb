module LazyDataApi
  class Relation < ActiveRecord::Base
    self.table_name_prefix = 'lazy_data_api_'
    belongs_to :apiable, polymorphic: true

    validate :api_id, uniqueness: true, present: true
  end
end
