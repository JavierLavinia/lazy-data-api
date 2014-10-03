LazyDataApi::Engine.routes.draw do
  get "(/*namespaces)/:resource_name/:api_id/:forward_action/:server_name" => "api#forward", as: 'forward_resource', defaults: {format: :json}
  get "(/*namespaces)/:resource_name/:api_id" => "api#show", as: 'show_resource', defaults: {format: :json}
  post "(/*namespaces)/:resource_name/:api_id" => "api#create", as: 'create_resource', defaults: {format: :json}
  put "(/*namespaces)/:resource_name/:api_id" => "api#update", as: 'update_resource', defaults: {format: :json}
end
