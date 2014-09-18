module LazyDataApi
  module ButtonsHelper
    def send_lazy_data resource, options = {}
      content_tag :div, class: 'send-lazy-data' do
        resource.api_servers.each do |name, url_options|
          namespaces = resource.class.name.deconstantize.underscore.gsub('::','/')
          resource_name = resource.class.name.demodulize.underscore
          url_options = url_options.merge namespaces: namespaces, resource_name: resource_name, api_id: resource.api_id
          concat button_to(t(".send_lazy_data.#{name}", default: t("shared.send_lazy_data.#{name}")), lazy_data_api.create_resource_url(url_options), options)
        end
      end
    end
  end
end
