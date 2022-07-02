Rails.application.routes.draw do
  resources :course_instances
  resources :event_types
  resources :course_events
  resources :academic_periods

  post "/inscribe-course" => "main#inscribeCourse"
  post "/uninscribe-all" => "main#uninscribeAllCourses"
  post "/debug-clear-session" => "main#debugClearSession"

  # MainController
  get "/home" => "main#home"
  get "/courses" => "main#courses"
  get "/schedule" => "main#schedule"
  get "/evaluations" => "main#evaluations"

  # SessionsController
  get "sessions/new" => "sessions#new"
  get "sessions/create" => "sessions#create"

  # PagesController
  get "/" => "pages#home"
  get "/pages/about" => "pages#about"
  get "/pages/not-found" => "pages#not_found"
  # Some legal stuff here required for Google Oauth
  get "/pages/privacy-policy" => "pages#privacy_policy"
  get "/pages/terms-of-service" => "pages#terms_of_service"

  # OmniAuth
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/google_oauth2/callback" => "sessions#create"
  get "/login" => "sessions#new"
  get "/google-auth/custom-redirect" => "pages#awesome" # callback for Google Oauth

  root "pages#home"
end
