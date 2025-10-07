Campfire::Engine.routes.draw do
  resources :rooms, only: [:index, :show]

  root to: "rooms#index"
end
