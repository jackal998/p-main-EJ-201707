Rails.application.routes.draw do

  domain = Rails.application.config_for(:domain)
  constraints(host: 'www.' + domain) do
    match '/(*path)', to: 'services#www', via: [:get, :post]
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  put '/user/:id', to: 'users#update'
  get '/tension', to: 'services#tension'
  
  resources :stocks, only: [:index, :show]
  resources :companies, only: [:index, :show]

  root :to => 'services#index'
  # no routes handler
  match '*path', to: 'services#noroutes', via: [:get, :post]
end
