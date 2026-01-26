Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "application#index"

  # Devise routes for User model
  devise_for :users, controllers: {
        registrations: "users/registrations"
      }

  # private routes (need authentication; defined first to avoid conflicts)
  authenticated :user do
    get "dashboard", to: "dashboard#index", as: :dashboard

      # routes for students
      namespace :students do
        get "dashboard", to: "dashboard#index", as: :dashboard

        resources :bookings, except: [ :edit, :destroy ] do
          member do
            post :checkout
            patch :cancel
            get :payment_success
            get :payment_failure
            get :payment_pending
          end
        end
      end

      # routes for mentors
      namespace :mentors do
        get "dashboard", to: "dashboard#index", as: :dashboard

        resources :availabilities

        resources :bookings, only: [ :index, :show, :update ]

        # each mentor can manage their own students
        resources :students, only: [ :index, :show ] do
          collection do
            get :with_bookings
          end
        end
      end
  end

  # public routes, no auth needed (defined after authenticated routes to avoid conflicts)
  resources :mentors, only: [ :index, :show ] do
    member do
      get :weekly_schedule
    end
  end

  resources :categories, only: [ :index, :show ] do
    member do
      get :availabilities
    end
  end

  post "/webhooks/mercadopago", to: "webhooks#mercadopago"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
