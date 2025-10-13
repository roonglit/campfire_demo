Campfire::Engine.routes.draw do
  root "welcome#show"

  resources :users, only: :show do
    scope module: "users" do

      scope defaults: { user_id: "me" } do
        resource :sidebar, only: :show
      end
    end
  end

  resources :rooms do
    resources :messages, only: [:create, :edit, :update, :destroy]

    scope module: "rooms" do
      resource :refresh, only: :show
    end
  end

  namespace :rooms do
    resources :opens
    resources :closeds
    resources :directs
  end

  resources :directs, only: [:new, :create]
  resource :sidebar, only: [:show]

  resources :searches, only: %i[ index create ] do
    delete :clear, on: :collection
  end
end
