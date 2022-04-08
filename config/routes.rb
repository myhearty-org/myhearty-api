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

    resource :organization, path: :org, only: %i[show create update] do
      get "/campaigns", action: "fundraising_campaigns"
      get "volunteer-events"
      get "/aids", action: "charitable_aids"

      post "stripe-onboard"
      get "stripe-onboard-refresh"
    end

    resources :members, only: %i[index show create destroy]

    scope module: :api do
      scope module: :v0 do
        resources :organizations, path: :orgs, only: %i[index show] do
          resources :charitable_aids, path: :aids, only: %i[index]
          resources :fundraising_campaigns, path: :campaigns, only: %i[index]
          resources :volunteer_events, path: "volunteer-events", only: %i[index]
        end

        resources :charitable_aids, path: :aids, only: %i[index show create update] do
          resources :charitable_aid_applications, path: "aid-applications", shallow: true, only: %i[index show update]
        end

        resources :fundraising_campaigns, path: :campaigns, only: %i[index show create update] do
          post "donate", on: :member

          resources :donations, shallow: true, only: %i[index show]
        end

        resources :volunteer_events, path: "volunteer-events", only: %i[index show create update] do
          resources :volunteer_applications, path: "volunteer-applications", shallow: true, only: %i[index show update]
        end

        namespace :users do
          resources :donations, only: %i[index]

          resources :charitable_aid_applications, path: "aid-applications", only: %i[index] do
            collection do
              get "/:charitable_aid_id", to: "charitable_aid_applications#applied"
              post "/:charitable_aid_id", to: "charitable_aid_applications#apply"
              delete "/:charitable_aid_id", to: "charitable_aid_applications#unapply"
            end
          end

          resources :volunteer_applications, path: "volunteer-applications", only: %i[index] do
            collection do
              get "/:volunteer_event_id", to: "volunteer_applications#applied"
              post "/:volunteer_event_id", to: "volunteer_applications#apply"
              delete "/:volunteer_event_id", to: "volunteer_applications#unapply"
            end
          end
        end
      end
    end

    namespace :webhooks do
      post :stripe, to: "stripe#create"
    end
  end
end
