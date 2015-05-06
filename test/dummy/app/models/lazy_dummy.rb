class LazyDummy < ActiveRecord::Base
  attr_accessible :integer, :string, :text

  validates :integer, numericality: { only_integer: true }

  lazy_data
end
