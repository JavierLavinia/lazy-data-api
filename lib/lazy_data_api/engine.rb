# CURRENT FILE :: lib/lazy_data_api/engine.rb
module LazyDataApi

  class Engine < Rails::Engine

    initialize "lazy_data_api.load_app_instance_data" do |app|
      LazyDataApi.setup do |config|
        config.app_root = app.root
      end
    end

    initialize "lazy_data_api.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end

end
