Rails.application.routes.draw do
  root to: 'web/boards#show'

  scope module: :web do
    resource :board, only: :show
    resources :developers, only: %i[new create]
    resource :session, only: %i[new create destroy]
  end

  namespace :admin do
    resources :users
  end
end
