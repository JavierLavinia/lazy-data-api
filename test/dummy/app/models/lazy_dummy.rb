class LazyDummy < ActiveRecord::Base
  attr_accessible :integer, :string, :text

  lazy_data
end
