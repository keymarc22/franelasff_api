# frozen_string_literal: true

Rails.application.routes.draw do
  # scope :api, defaults: { format: :json } do
  #   devise_for :users, controllers: { sessions: :sessions },
  #                      path_names: { sign_in: :login }
  # end

  get "/health", to: "health#health"
  resources :stores
  resources :shirts
end
