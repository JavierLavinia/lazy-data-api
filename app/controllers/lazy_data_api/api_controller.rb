module LazyDataApi
  class ApiController < ::ApplicationController
    before_filter :get_resource

    def show
      render json: @resorce.to_json
    end

    private

    def get_resource
      # TODO: check if the resource exists and is apiable
      resource_class = params[:resource_name].classify.constantize
      @resource = resource_class.where(api_id: params[:api_id]).first
    end
  end
end
