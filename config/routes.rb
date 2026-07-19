Rails.application.routes.draw do
  get "/portfolio", to: 'portfolio#index', as: :portfolio
  
  namespace :admin do
    resources :users
  end

  # Uses your custom 2FA sessions interceptor
  devise_for :users, controllers: { sessions: 'users/sessions' }

  # 2FA registration and login challenge checkpoints
  resources :two_factor_settings, only: [:new, :create]
  get '/user/otp_verification', to: 'otp_verifications#new', as: :user_otp_verification
  post '/user/otp_verification', to: 'otp_verifications#create'

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
  post "upload", to: "dashboard#upload"
end
