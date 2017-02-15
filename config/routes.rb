Rails.application.routes.draw do

  devise_for :users

  resources :users

  get '/services/hereyouare', to: 'services#marketing'

  root :to => "services#index"
end
