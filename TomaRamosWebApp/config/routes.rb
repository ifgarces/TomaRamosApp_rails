Rails.application.routes.draw do
  get "/home" => "pages#home"
  get "/about" => "pages#about"
  get "/wip"  => "pages#wip"

  root "pages#about"
  #root "pages#home"
end
