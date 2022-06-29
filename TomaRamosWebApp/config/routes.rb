Rails.application.routes.draw do
  resources :course_instances
  resources :event_types
  resources :course_events
  resources :academic_periods

  # MainController
  get "main/home"
  get "main/courses"
  get "main/schedule"
  get "main/evaluations"

  # SessionsController
  get "sessions/new" => "sessions#new"
  get "sessions/create" => "sessions#create"

  # PagesController
  get "/" => "pages#home"
  get "/about" => "pages#about"
  get "/wip" => "pages#wip"
  get "/not-found" => "pages#not_found"
  # Some legal stuff here required for Google Oauth
  get "/privacy-policy" => "pages#wip" #TODO
  get "/terms-of-service" => "pages#wip" #TODO

  # OmniAuth
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/google_oauth2/callback" => "sessions#create"
  get "/login" => "sessions#new"
  get "/google-auth/custom-redirect" => "pages#awesome" # callback for Google Oauth

  root "pages#home"
end
