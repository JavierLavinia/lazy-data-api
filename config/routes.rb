Rails.application.routes.draw do
  get "lazy-data-api/:resource/:api_id" => "lazy_data_api/api#show" , :as => :lazy_data_api
end
