# frozen_string_literal: true

Rails.application.routes.draw do
  # for unknown reason, omniauth_callbacks_controller must be declared
  # in devise_for block, otherwise passthru method will not work
  devise_for :users,
             only: :omniauth_callbacks,
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    scope :users, as: :user do
      post "/sign_in", to: "devise/sessions#create"
      post "/sign_out", to: "devise/sessions#destroy"

      post "/sign_up", to: "devise/registrations#create"

      post "/password", to: "devise/passwords#create"
      patch "/password", to: "devise/passwords#update"

      get "/confirmation", to: "users/confirmations#show"

      post "/unlock", to: "devise/unlocks#create"
      get "/unlock", to: "devise/unlocks#show"
    end
  end

  devise_for :members, skip: :all

  devise_scope :member do
    scope :members, as: :member do
      post "/sign_in", to: "members/sessions#create"
      post "/sign_out", to: "members/sessions#destroy"

      post "/sign_up", to: "members/registrations#create"

      post "/password", to: "members/passwords#create"
      patch "/password", to: "members/passwords#update"

      get "/confirmation", to: "members/confirmations#show"

      post "/unlock", to: "members/unlocks#create"
      get "/unlock", to: "members/unlocks#show"
    end
  end
end
