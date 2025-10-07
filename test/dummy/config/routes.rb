Rails.application.routes.draw do
  devise_for :users
  mount Campfire::Engine => "/campfire"
end
