module LazyDataApi
  module ButtonsHelper
    def send_lazy_data resource, options = {}
      content_tag :div, class: 'send-lazy-data' do
        resource.api_servers.collect do |api_server|
          namespaces = resource.class.name.deconstantize.downcase.gsub('::','/')
          resource_name = resource.class.name.demodulize.downcase
          url_options = api_server[:url_options].merge namespaces: namespaces, resource_name: resource_name, api_id: resource.api_id
          concat button_to(t(".send_lazy_data.#{api_server[:name]}"), lazy_data_api.create_resource_url(url_options), options)
        end
      end
    end
  end
end
