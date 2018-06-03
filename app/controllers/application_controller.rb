class ApplicationController < ActionController::Base
  # CSRF
  protect_from_forgery with: :exception, prepend: true

  # Pundit
  include Pundit
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
