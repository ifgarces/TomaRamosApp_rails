Rails.application.routes.draw do
  get "/home" => "pages#home"
  get "/about" => "pages#about"
  get "/wip" => "pages#wip"
  get "/not-found" => "pages#not_found"

  root "pages#about"
  #root "pages#home"
end
