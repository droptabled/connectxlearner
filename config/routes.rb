Rails.application.routes.draw do
  resources :games do
    resources :bots do
      resources :play, only: :index
    end
  end
  root controller: :games, action: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
