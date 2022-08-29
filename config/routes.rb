Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  resources :games do
    resources :bots
  end

  resources :play, only: :show

  root controller: :games, action: :index
end
