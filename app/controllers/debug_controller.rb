class DebugController < ApplicationController
  before_action :ensure_development!

  def login
    skip_authorization
    session[:user_id] = params[:user_id]
    redirect_to apps_url
  end

private
  def ensure_development!
    not_found unless Rails.env.development?
  end
end
