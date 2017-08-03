Rails.application.routes.draw do

  domain = Rails.application.config_for(:domain)
  constraints(host: 'www.' + domain) do
    match '/(*path)', to: 'services#www', via: [:get, :post]
  end

  devise_for :users
  resources :users

  get '/tension', to: 'services#tension'
  get '/testview', to: 'services#testview'
  
  root :to => 'services#index'
  # no routes handler
  match '*path', to: 'services#noroutes', via: [:get, :post]
end
