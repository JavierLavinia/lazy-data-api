Rails.application.routes.draw do
  namespace :lazy_data_api, defaults: {format: :json} do
    get ":resource_name/:api_id" => "api#show"
  end
end
