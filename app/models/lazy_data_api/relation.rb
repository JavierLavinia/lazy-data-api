module LazyDataApi
  class Relation < ActiveRecord::Base
    self.table_name_prefix = 'lazy_data_api_'
    belongs_to :apiable, polymorphic: true

    validates :api_id, presence: true, uniqueness: { scope: :apiable_type }

    after_initialize :generate_api_id, unless: :api_id

    def generate_api_id
      self.api_id = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        unless ::LazyDataApi::Relation.exists?(apiable_type: apiable_type, api_id: random_token)
          break random_token
        end
      end
    end
  end
end
