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
      server_url_params = {
        protocol: "#{server_url.scheme}://",
        host: server_url.host,
        port: server_url.port,
        only_path: false,
        resource_name: params[:resource_name],
        api_id: params[:api_id]
      }

      resource_data = get_resource_data show_resource_url(server_url_params)
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
        resource_class.find_for_api params[:api_id]
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
