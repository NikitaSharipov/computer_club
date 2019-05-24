Rails.application.routes.draw do

  devise_for :users

  resources :computers, only: [:index, :show], shallow: true do
    resources :software_requests, only: [:create]
  end


  root to: "computers#index"

end
