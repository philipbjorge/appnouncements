class ApplicationController < ActionController::Base
  # Pundit
  include Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    current_user != nil
  end

  def authenticate_user!
    redirect_to "/auth/auth0" unless logged_in?
  end

  helper_method :current_user, :logged_in?

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
