Rails.application.routes.draw do
  resources :snapshots, :only => [:index]
  resources :sites, :only => [:index]
  get 'trending', to: 'stories#trending'
end
