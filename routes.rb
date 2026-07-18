# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  # This is the line that creates the path 'admin_users_path' mapped to /admin/users
  namespace :admin do
    resources :users
  end

  get '/dashboard', to: "dashboard#index", as: :dashboard

  root to: 'dashboard#index'
  post "upload", to: "dashboard#upload"
end
