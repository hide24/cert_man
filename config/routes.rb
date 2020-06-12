Rails.application.routes.draw do
  resources :organizations
  resources :hosts do
    resources :certificates, shallow: true
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'hosts#index'
end
