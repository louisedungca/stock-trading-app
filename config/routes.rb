# == Route Map
#

Rails.application.routes.draw do
  root "pages#landing"

  devise_for :users

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :trader, path: 't' do
    get 'dashboard', to: 'dashboard#index'
  end

  # routes for static pages
  get 'landing', to: 'pages#landing', as: :landing_page
  get 'pending-approval', to: 'pages#pending_approval', as: :pending_approval_page
end
