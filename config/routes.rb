require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? || u.owner? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  resources :computers, only: %i[index show create destroy], shallow: true do
    resources :software_requests, only: [:create]
  end

  resources :users do
    get :account_replenish, on: :collection
    post :replenish, on: :member
    get :reservations, on: :member
  end

  resource :admin_panel, only: [:show] do
    get :reservation, on: :collection
  end

  resource :owner_panel, only: [:show]

  resources :reservations, only: %i[index destroy create] do
    post :date, on: :collection
    post :pay, on: :member
    get :payment, on: :collection
  end

  resources :reports, only: %i[show create index destroy] do
    get :option, on: :collection
  end

  root to: "computers#index"

  mount ActionCable.server => '/cable'
end
