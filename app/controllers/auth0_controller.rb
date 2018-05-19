class Auth0Controller < ApplicationController
  def callback
    auth_context = request.env['omniauth.auth']
    session[:user_id] = User.find_or_create_by!(auth0_id: auth_context[:uid]).id
    redirect_to apps_url
  end

  def failure
    # TODO
  end

  def signout
    skip_authorization
    reset_session
    # TODO redirect to auth0
    redirect_to root_path
  end
end
