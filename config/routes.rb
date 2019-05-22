Rails.application.routes.draw do

  devise_for :users

  resources :computers, only: [:index, :show]

  root to: "computers#index"

end
