# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all

  devise_scope :user do
    scope :users do
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
end
