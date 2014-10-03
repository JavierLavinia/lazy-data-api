module LazyDataApi
  module ButtonsHelper
    def create_lazy_data resource, options = {}
      send_lazy_data :create, resource, options
    end

    def update_lazy_data resource, options = {}
      send_lazy_data :update, resource, options
    end

    # Action should be 'create' or 'update'
    def send_lazy_data action, resource, options = {}
      content_tag :div, class: 'send-lazy-data' do
        resource.api_servers.each do |name, url_options|
          url_options = resource.url_options.merge server_name: name, action: action
          send_url = lazy_data_api.forward_resource_url url_options
          concat link_to(t(".#{action}_lazy_data.#{name}", default: t("shared.#{action}_lazy_data.#{name}")), send_url, options)
        end
      end
    end

  end
end
