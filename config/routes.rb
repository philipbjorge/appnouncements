Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'user/registrations' }
  devise_scope :user do
    get 'settings/profile', to: 'user/registrations#edit', as: "edit_profile"
    put 'settings/profile/:id', to: 'user/registrations#update', as: "update_profile"
  end
  
  scope :settings do
    resource :billing do
      member do
        post "hosted_page"
        post "portal_session"
      end
    end
  end

  resolve('Billing') { [:billings] }
  
  namespace :api do
    namespace :v1 do
      get 'release_notes/:uuid(/:start_version...(:end_version))' => "release_notes#show"
      get 'release_notes/:uuid/...(:end_version)' => "release_notes#show", defaults: { start_version: nil }
      
      get 'configuration/:uuid(/:start_version...(:end_version))' => "release_notes#configuration"
      get 'configuration/:uuid/...(:end_version)' => "release_notes#configuration", defaults: { start_version: nil }

      patch 'release_notes/:uuid/preview' => "release_notes#preview"
      post 'release_notes/:uuid/preview' => "release_notes#preview"
    end
  end

  post '/webhooks/chargebee' => 'charge_bee_webhook#consume'

  if Rails.env.production?
    authenticated :user, -> user { user.admin? }  do
      mount DelayedJobWeb, at: "/delayed_job"
    end
  end
  
  match '/404', :to => 'error#error_404', :via => :all
  match '/422', :to => 'error#error_422', :via => :all
  match '/500', :to => 'error#error_500', :via => :all
  root "apps#index"
  resources :apps do
    get :integration, on: :member
    post :attach, on: :member
    resources :releases
  end
end
