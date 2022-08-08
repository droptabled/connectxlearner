Rails.application.routes.draw do
  resources :games do
    resources :bots
  end

  resources :play, only: :show

  root controller: :games, action: :index
end
