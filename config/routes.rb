Rails.application.routes.draw do
  resources :certificate_applications do
    member do
      get 'certificates'
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
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'vue#index'
end
