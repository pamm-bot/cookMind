Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :profils, only: [:show, :edit, :update]
  resources :recipes, only: [:index, :show]

  resources :ingredients, only: [:index, :create] do
    resources :chats, only: [:show, :create]
  end

  resources :chats, only: [:show, :create] do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
