# == Route Map
#

Rails.application.routes.draw do
  authenticated :user, ->(user) { user.admin? } do
    root 'admin/dashboard#index', as: :admin_root
  end

  authenticated :user, ->(user) { user.trader? } do
    root 'trader/dashboard#index', as: :trader_root
  end

  root 'pages#landing'

  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    },
    controllers: {
      sessions: 'users/sessions',
      invitations: 'users/invitations'
    },
    skip: [:registrations]

  # routes for user registrations controller
  devise_scope :user do
    get '/register', to: 'users/registrations#new', as: :new_user_registration
    get 'users/cancel', to: 'users/registrations#cancel', as: :cancel_user_registration
    get 'users/edit', to: 'users/registrations#edit', as: :edit_user_registration
    post 'users', to: 'users/registrations#create', as: :user_registration
    patch 'users', to: 'users/registrations#update', as: :update_user_registration
    delete 'users', to: 'users/registrations#destroy', as: :destroy_user_registration
  end

  namespace :admin do
    resources :users, except: [:new, :create]
    resources :transactions, only: [:index]
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :trader, path: 't' do
    resources :transactions, only: [:index]
    get 'dashboard', to: 'dashboard#index'
    get 'market', to: 'dashboard#market', as: :market_page
    get 'cash-in', to: 'cash_in#index'
    patch 'cash-in', to: 'cash_in#update'
    get 'trade', to: 'trades#index'
    post 'trade/buy', to: 'trades#buy'
    post 'trade/sell', to: 'trades#sell'
    get 'portfolio', to: 'portfolios#index'
  end

  resources :statuses, only: [:edit, :update]

  # routes for static pages
  get 'landing', to: 'pages#landing', as: :landing_page
  get 'pending-verification', to: 'pages#pending_verification', as: :pending_verification_page
end
