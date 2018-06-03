Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'release_notes/:uuid(/:start_version...(:end_version))' => "release_notes#show"
      get 'release_notes/:uuid/...(:end_version)' => "release_notes#show", defaults: { start_version: nil }

      patch 'release_notes/:uuid/preview' => "release_notes#preview"
      post 'release_notes/:uuid/preview' => "release_notes#preview"
    end
  end

  root "apps#index"
  resources :apps do
    resources :releases do
      post :attach, on: :member
    end
  end
end
