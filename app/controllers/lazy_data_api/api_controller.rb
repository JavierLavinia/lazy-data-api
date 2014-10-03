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
      server_url_options = @resource.server_url_options params[:server_name]
      unless server_url_options.blank?
        response = send_resource params[:forward_action], @resource.to_api.to_json, create_resource_url(server_url_options), request.referer
        unless response.blank?
          render json: response.body, status: get_response_status(response)
        else
          render json: { error: 'No action available' }, status: :error
        end
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

    def update
      resource_data = params[params[:resource_name]] if params[:resource_name]
      resource = resource_class.find_for_api params[:api_id]
      unless resource.blank?
        server_url = URI(request.referer)
        server_host = "#{server_url.scheme}://#{server_url.host}:#{server_url.port}"
        resource.update_api_resource resource_data, server_host
        if resource.valid?
          render nothing: true, status: :ok
        else
          render nothing: true, status: :error
        end
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

    def send_resource action, data, url, referer
      request_class = case action
        when 'create' then Net::HTTP::Post
        when 'update' then Net::HTTP::Put
        else nil
      end
      unless request_class.blank?
        uri = URI.parse url
        http = Net::HTTP.new(uri.host, uri.port)
        request = request_class.new(uri.path, {
          'Referer' => referer,
          'Content-Type' => 'application/json'
        })
        request.basic_auth uri.user, uri.password unless uri.user.blank? || uri.password.blank?
        request.use_ssl = true if uri.scheme == 'https'
        request.body = data
        http.request(request)
      else
        nil
      end
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
