Rails.application.routes.draw do
  namespace :api do
    get 'users/search', to: 'users#search'
  end
end
