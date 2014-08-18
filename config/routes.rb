Rails.application.routes.draw do
  namespace :lazy_data_api, path: 'lazy-data-api', defaults: {format: :json} do
    get ":resource/:api_id" => "lazy_data_api/api#show" , as: :lazy_data_api
  end
end
