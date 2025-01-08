Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get '/' => 'users#index'

  scope :api do
    scope :v1 do
      resources :accounts, only: %i[show create index] do
        resources :transactions, only: [:index, :create]
      end
      resources :recipients, only: %i[index create]
      resources :services, only: [:index]
      post 'accounts/:id/pay_service', to: 'accounts#pay_service'
  
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
  
      get '/accounts/:account_id/transactions', to: 'transactions#index'

      resources :users, only: [:update]
    end
  end
  
end
