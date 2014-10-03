require 'net/http'

module LazyDataApi
  class ApiController < ApplicationController
    before_filter :get_resource, only: [:show, :forward]

    def show
      if @resource
        render json: @resource.to_api
      else
        render nothing: true, status: :not_found
      end
    end

    def forward
      url_options = @resource.api_servers[params[:server_name].to_sym]
      unless url_options.blank?
        server_url_params = url_options.merge only_path: false,
          namespaces: params[:namespaces],
          resource_name: params[:resource_name],
          api_id: params[:api_id]
        response = create_resource @resource.to_api.to_json, create_resource_url(server_url_params), request.referer
        render json: response.body, status: get_response_status(response)
      else
        render nothing: true, status: :not_found
      end
    end

    def create
      resource_data = params[params[:resource_name]] if params[:resource_name]
      server_url = URI(request.referer)
      server_host = "#{server_url.scheme}://#{server_url.host}:#{server_url.port}"
      resource = resource_class.create_api_resource resource_data, server_host
      if resource.valid?
        render nothing: true, status: :ok
      else
        render nothing: true, status: :not_found
      end
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
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.path)
      response = http.request(request)
      ActiveSupport::JSON.decode(response.body)
    end

    def create_resource data, url, referer
      uri = URI.parse url
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, {
        'Referer' => referer,
        'Content-Type' =>'application/json'
      })
      request.body = data
      http.request(request)
    end

    def get_response_status response
      case response
        when Net::HTTPOK then :ok
        when Net::HTTPNotFound then :not_found
        else :error
      end
    end
  end
end
