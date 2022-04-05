# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    # for unknown reason, omniauth_callbacks_controller must be declared
    # in devise_for block, otherwise passthru method will not work
    devise_for :users,
               only: :omniauth_callbacks,
               controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

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

    devise_for :members, skip: :all

    devise_scope :member do
      scope :members, as: :member do
        post "/sign_in", to: "members/sessions#create"
        post "/sign_out", to: "members/sessions#destroy"

        post "/password", to: "members/passwords#create"
        patch "/password", to: "members/passwords#update"

        get "/confirmation", to: "members/confirmations#show"

        post "/unlock", to: "members/unlocks#create"
        get "/unlock", to: "members/unlocks#show"
      end
    end

    resources :organizations, path: :orgs, only: %i[create]

    scope module: :api do
      scope module: :v0 do
        resources :organizations, path: :orgs, only: %i[index show update] do
          resources :charitable_aids, path: :aids, shallow: true, only: %i[index show create update]
          resources :fundraising_campaigns, path: :campaigns, shallow: true, only: %i[index show create update]
          resources :volunteer_events, shallow: true, only: %i[index show create update]
        end

        resources :charitable_aids, path: :aids, only: %i[index]
        resources :fundraising_campaigns, path: :campaigns, only: %i[index]
        resources :volunteer_events, only: %i[index] do
          resources :volunteer_applications, shallow: true, only: %i[index show update]
        end

        namespace :users do
          resources :volunteer_applications, only: %i[index] do
            collection do
              get "/:volunteer_event_id", to: "volunteer_applications#applied"
              post "/:volunteer_event_id", to: "volunteer_applications#apply"
              delete "/:volunteer_event_id", to: "volunteer_applications#unapply"
            end
          end
        end
      end
    end
  end
end
