# frozen_string_literal: true

require "devise_token_auth"

Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth"

  root to: "home#index"
  get "/health", to: "health#health"

  namespace :api do
    namespace :v1 do
      resources :stores
      resources :shirts
      resources :catalogues
      resources :users
    end

    scope :v1 do
      mount_devise_token_auth_for "User", at: "auth"
    end
  end
end
