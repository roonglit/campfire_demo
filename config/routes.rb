Campfire::Engine.routes.draw do
  root "welcome#show"

  resources :rooms do
    resources :messages, only: [:create, :edit, :update, :destroy]
  end

  resources :users, only: :show do
    scope module: "users" do

      scope defaults: { user_id: "me" } do
        resource :sidebar, only: :show
      end
    end
  end

  resources :directs, only: [:new, :create]
  resource :sidebar, only: [:show]
end
