Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Sidekiq::Web => '/admin/sidekiq'
  root to: 'web/boards#show'

  scope module: :web do
    resource :board, only: :show
    resources :developers, only: %i[new create]
    resource :session, only: %i[new create destroy]
    resources :password_resets, only: [:new, :create, :edit, :update]
  end

  namespace :admin do
    resources :users
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:index, :show]
    end
  end
end
