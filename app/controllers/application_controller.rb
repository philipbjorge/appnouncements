class ApplicationController < ActionController::Base
  # CSRF
  protect_from_forgery with: :exception, prepend: true

  # Pundit
  include Pundit
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  before_action :set_raven_context
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  private
  def set_raven_context
    Raven.user_context(id: current_user.id) if current_user
    Raven.extra_context(params: request.filtered_parameters, url: request.url)
  end
end
