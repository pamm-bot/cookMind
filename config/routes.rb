Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :profils, only: [:show, :edit, :update]
  resources :recipes, only: [:index, :show, :destroy]
  resources :chats, only: [:index, :show, :create]
  resources :messages, only: [:create]
  resources :ingredients, only: [:index, :create, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
