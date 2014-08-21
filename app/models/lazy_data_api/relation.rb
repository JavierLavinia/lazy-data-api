module LazyDataApi
  class Relation < ActiveRecord::Base
    self.table_name_prefix = 'lazy_data_api_'
    belongs_to :apiable, polymorphic: true

    validates :api_id, presence: true, uniqueness: { scope: :apiable_type }
  end
end
