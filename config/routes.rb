# == Route Map
#

Rails.application.routes.draw do
  root "pages#landing"

  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout'
    },
    controllers: {
      sessions: 'users/sessions',
      invitations: 'users/invitations' },
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
    get 'dashboard', to: 'dashboard#index'
    # get 'pending_approvals', to: 'dashboard#pending_approvals'
    # get 'all_traders', to: 'dashboard#index'
    resources :users, except: [:new, :create] ## for editing user details
    # resources :transactions
  end

  namespace :trader, path: 't' do
    get 'dashboard', to: 'dashboard#index'
    # resources :transactions
    # resources :stocks
  end

  resources :statuses, only: [:edit, :update]

  # routes for static pages
  get 'landing', to: 'pages#landing', as: :landing_page
  get 'pending-verification', to: 'pages#pending_verification', as: :pending_verification_page
  get 'market', to: 'pages#market', as: :market_page
end
