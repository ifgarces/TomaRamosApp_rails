Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"

  # PagesController
  get "/home" => "pages#home"
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

  get "/google-auth/custom-redirect" => "pages#awesome"

  root "pages#home"
end
