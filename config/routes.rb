require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  resources :computers, only: [:index, :show], shallow: true do
    get :reservation, on: :collection
    post :reservation, on: :collection
    post :reserve, on: :member
    resources :software_requests, only: [:create]
    get :payment, on: :collection
    post :pay, on: :member
  end

  resources :users do
    get :account_replenish, on: :collection
    post :replenish, on: :member
  end

  root to: "computers#index"

  mount ActionCable.server => '/cable'
end
