Rails.application.routes.draw do
  resources :snapshots, only: [:index] do
    get "headlines", to: "headlines#index", on: :member
  end

  resources :sites, only: [:index]

  get 'trending', to: 'stories#trending'
  get 'impact', to: 'stories#impact'
end
