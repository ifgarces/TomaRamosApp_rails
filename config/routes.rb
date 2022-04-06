Rails.application.routes.draw do
  resources :ramo_events
  resources :ramos
  resources :academic_periods
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "pages#home"
  # Defines the root path route ("/")
  # root "articles#index"
end
