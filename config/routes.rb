# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  notify_to :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :devices, only: %i[create show]
      post 'readings', to: 'readings#create'
    end
  end

  resources :devices, only: %i[index show]
  resources :users

  root to: 'devices#index'
end
