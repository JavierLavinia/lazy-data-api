module LazyDataApi
  class ApiController < ::ApplicationController
    before_filter :get_resource

    def show
      render_params =  if @resource
        { json: @resource.to_json }
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
  end
end
