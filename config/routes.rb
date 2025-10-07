Campfire::Engine.routes.draw do
  resources :rooms do
    resources :messages, only: [:create, :edit, :update, :destroy]
  end

  resources :directs, only: [:new, :create]
  resource :sidebar, only: [:show]

  root to: "rooms#index"
end
