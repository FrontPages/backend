Rails.application.routes.draw do
  get "impact", to: "stories#impact"
  get "sites", to: "sites#index"
  get "snapshots", to: "snapshots#index"
  get "snapshots/:id/headlines", to: "headlines#index"
  get "trending", to: "stories#trending"
end
