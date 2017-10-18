Rails.application.routes.draw do
  root 'home#index'
  # root to: 'rooms#show'
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
