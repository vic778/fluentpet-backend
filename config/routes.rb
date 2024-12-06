Rails.application.routes.draw do
  get "home/index"
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  root to: "home#index"
  scope :api, defaults: { format: :json } do
    resources :dog_profiles, only: [ :create ]
    resources :button_events, only: [ :create ]
  end
end
