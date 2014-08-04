Rails.application.routes.draw do
  root "subscription_events#index"
  get "signin" => "sessions#new", as: :signin
  post "signin" => "sessions#create"
  get "signout" => "sessions#destroy", as: :signout
  get "reports" => "reports#index"
  get "reports/current-members" => "reports#current_members"
  get "reports/lifetime-value" => "reports#lifetime_value"
end
