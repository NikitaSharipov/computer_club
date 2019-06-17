Rails.application.routes.draw do
  devise_for :users

  resources :computers, only: [:index, :show], shallow: true do
    get :reservation, on: :collection
    post :reservation, on: :collection
    post :reserve, on: :member
    resources :software_requests, only: [:create]
  end


  root to: "computers#index"
end
