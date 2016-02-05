Rails.application.routes.draw do
  get "impact", to: "stories#impact"
  get "sites", to: "sites#index"
  get "snapshots", to: "snapshots#index"
  get "headlines", to: "headlines#index"
  get "trending", to: "stories#trending"

  resources :collections, only: [:index, :create]
  get "collections/:permalink", to: "collections#show"

  get "snapshots/search", to: "snapshots#search"

end
