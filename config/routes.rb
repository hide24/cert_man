Rails.application.routes.draw do
#  resources :renewals
  resources :certificate_applications do
    member do
      get 'certificates'
      post 'upload'
    end
  end
  resources :organizations do
    collection do
      get 'schema'
    end
    member do
      get 'dup'
    end
  end
  resources :hosts do
    collection do
      get 'schema'
    end
    resources :certificates, shallow: true
    resource :renewal
  end
  get 'renewal/schema', to: 'renewals#schema'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  root to: 'vue#index'
end
