Rails.application.routes.draw do
  root "pages#landing"

  devise_for :users

  # routes for static pages
  get 'landing', to: 'pages#landing', as: :landing_page
end
