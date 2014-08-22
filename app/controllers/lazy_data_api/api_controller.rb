require 'net/http'

module LazyDataApi
  class ApiController < ::ApplicationController
    before_filter :get_resource, only: :show

    def show
      render_params = if @resource
        { json: @resource.to_api }
      else
        { nothing: true, status: :not_found }
      end
      render render_params
    end

    def create
      url_params = {
        host: "http://localhost:3000",
        only_path: false,
        resource_name: params[:resource_name],
        api_id: params[:api_id]
      }
      resource_data = get_resource_data lazy_data_api_path(url_params)
      resource_class = params[:resource_name].classify.constantize

      render_params = if resource_class.create resource_data[params[:resource_name]]
        { nothing: true, status: :ok }
      else
        { nothing: true, status: :not_found }
      end
      render render_params
    end

    private

    def get_resource
      resource_class = params[:resource_name].classify.constantize
      @resource = if resource_class.apiable?
        resource_class.find_for_api resource_class.name, params[:api_id]
      end
    end

    def get_resource_data url
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.to_s)
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }
      ActiveSupport::JSON.decode(response.body)
    end
  end
end
