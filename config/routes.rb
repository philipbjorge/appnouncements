Rails.application.routes.draw do
  root 'welcome#index'
  resources :apps do
    resources :releases
  end

  # Auth0
  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
end
