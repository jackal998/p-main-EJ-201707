Rails.application.routes.draw do

  devise_for :users
  resources :users

  domain = Rails.application.config_for(:domain)

  constraints(host: 'www.' + domain) do
    match '/(*path)', to: 'services#www', via: [:get, :post]
  end
  
  root :to => 'services#index'
  # no routes handler
  match '*path', to: 'services#noroutes', via: [:get, :post]
end
