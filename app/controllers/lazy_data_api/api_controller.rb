require 'net/http'

module LazyDataApi
  class ApiController < ApplicationController
    before_filter :check_referrer, only: :create
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
      # A filter checksfor referer existence
      # Maybe is better use a default host when is empty
      server_url = URI(request.referer)
      server_host = "#{server_url.scheme}://#{server_url.host}:#{server_url.port}"
      server_url_params = {
        protocol: "#{server_url.scheme}://",
        host: server_url.host,
        port: server_url.port,
        only_path: false,
        namespaces: params[:namespaces],
        resource_name: params[:resource_name],
        api_id: params[:api_id]
      }

      resource_data = get_resource_data show_resource_url(server_url_params)
      render_params = if resource_class.create_api_resource resource_data[params[:resource_name]], server_host
        { nothing: true, status: :ok }
      else
        { nothing: true, status: :not_found }
      end
      render render_params
    end

    private

    def get_resource
      @resource = if resource_class.apiable?
        resource_class.find_for_api params[:api_id]
      end
    end

    # Memoize resource class from params
    # Namespaces params is the url part with all the class namespaces
    # /namespace1/namespace2/my_class/api_id turns into
    # Namespace1::Namespace2::MyClass
    def resource_class
      @resource_class ||= begin
        resource_parts = params[:namespaces] ? params[:namespaces].split('/') : []
        resource_parts << params[:resource_name]
        resource_parts.map(&:classify).join('::').constantize
      end
    end

    def get_resource_data url
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.to_s)
      response = Net::HTTP.start(uri.host, uri.port) {|http| http.request(request) }
      ActiveSupport::JSON.decode(response.body)
    end

    def check_referrer
      render json: { error: 'Referer url is needed on request' } if request.referer.blank?
    end
  end
end
