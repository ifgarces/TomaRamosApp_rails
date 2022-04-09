Rails.application.routes.draw do
    devise_for :users
    resources :ramo_events
    resources :ramos
    resources :academic_periods

    root "home#index"
    # after_sign_in_path_for "home#index"
    # after_sign_out_path_for "home#index"
end
