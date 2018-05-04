Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'release_notes/view'
    end
  end
  root 'welcome#index'
  resources :apps do
    resources :releases
  end

  # Auth0
  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/auth/signout" => "auth0#signout"
end
