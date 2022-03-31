# frozen_string_literal: true

Rails.application.routes.draw do
  # for unknown reason, omniauth_callbacks_controller must be declared
  # in devise_for block, otherwise passthru method will not work
  devise_for :users,
             only: :omniauth_callbacks,
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" },
             defaults: { format: :json }

  devise_scope :user do
    scope :users, as: :user do
      post "/sign_in", to: "users/sessions#create"
      post "/sign_out", to: "users/sessions#destroy"

      post "/sign_up", to: "users/registrations#create"

      post "/password", to: "users/passwords#create"
      patch "/password", to: "users/passwords#update"

      get "/confirmation", to: "users/confirmations#show"

      post "/unlock", to: "users/unlocks#create"
      get "/unlock", to: "users/unlocks#show"
    end
  end

  devise_for :members, skip: :all, defaults: { format: :json }

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
