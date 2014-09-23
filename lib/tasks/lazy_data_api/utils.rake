require 'fileutils'

namespace :lazy_data_api do

  desc 'Create api ids for apiable models without.'
  task :create_ids do
    puts ActiveRecord::Base.descendants.select(&:apiable?).map(&:create_api_ids)
  end
end
