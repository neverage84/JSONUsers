Rails.application.routes.draw do
  namespace :api do
    get 'users/search', to: 'users#search'
    get 'users', to: 'users#index'
  end
end
