Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'release_notes/:uuid' => "release_notes#show"
    end
  end

  root "apps#index"
  resources :apps do
    resources :releases do
      post :attach, on: :member
    end
  end

  if Rails.env.development?
    get '/login/:user_id' => "debug#login"
  end

  # Auth0
  get "/auth/oauth2/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"
  get "/auth/signout" => "auth0#signout"
end
