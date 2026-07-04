Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root to: "pages#home"

  resources :profils, only: [ :show, :edit, :update ]
  resources :recipes, only: [ :index, :show ]

  resources :ingredients, only: [ :index, :new, :create, :destroy ]

  resources :chats, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
