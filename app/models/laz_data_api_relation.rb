module LazyDataApi
  class LazyDataApiRelation < ActiveRecord::Base
    belongs_to :apiable, :polymorphic => true
  end
end
