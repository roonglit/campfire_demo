Campfire::Engine.routes.draw do
  resources :rooms, only: [:index, :show] do
    resources :messages, only: [:create, :edit, :update, :destroy]
  end

  root to: "rooms#index"
end
