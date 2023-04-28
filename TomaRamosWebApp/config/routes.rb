Rails.application.routes.draw do
  devise_for :users
  resources :course_instances
  resources :event_types
  resources :course_events

  # User-friendly alias
  get "/catalog" => "course_instances#index"

  # Custom safe error pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#server_error", via: :all

  # ------------------------- MainController ------------------------- #
  get "/home" => "main#home"
  get "/courses" => "main#courses"
  get "/schedule" => "main#schedule"
  get "/evaluations" => "main#evaluations"

  # Button actions
  post "/inscribe-course" => "main#inscribeCourse"
  post "/deinscribe-all" => "main#deinscribeAllCourses"
  post "/deinscribe" => "main#deinscribeCourse"
  get "/downloadSchedule" => "main#downloadSchedule" # has to be a GET since a file should be downloaded

  # ------------------------- PagesController ------------------------- #
  get "/" => "pages#home"
  get "/pages/about" => "pages#about"

  # Some legal stuff here required for Google Oauth
  #// get "/pages/privacy-policy" => "pages#privacy_policy"
  #// get "/pages/terms-of-service" => "pages#terms_of_service"

  # ------------------------- SessionsController ------------------------- #
  #// get "/sessions/new" => "sessions#new"
  #// get "/sessions/create" => "sessions#create"

  # ------------------------- OmniAuth ------------------------- #
  #// get "/auth/:provider/callback" => "sessions#create"
  #// get "/auth/google_oauth2/callback" => "sessions#create"
  #// get "/login" => "sessions#new"
  #// get "/google-auth/custom-redirect" => "pages#awesome" # callback for Google Oauth

  # Health check endpoint for docker-compose
  get "/healthcheck", to: proc { [200, {}, ["I am alright, thanks"]] }

  root "pages#home"
end
