class ApplicationController < ActionController::Base
  # Pundit
  include Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  impersonates :user
  helper_method :current_user, :logged_in?

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    current_user != nil
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
