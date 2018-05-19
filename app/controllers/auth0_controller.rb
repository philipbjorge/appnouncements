class Auth0Controller < ApplicationController
  def callback
    auth_context = request.env['omniauth.auth']
    session[:user_id] = User.find_or_create_by!(auth0_id: auth_context[:uid]).id
    redirect_to apps_url
  end

  def failure
    # TODO (raising right now instead of redirecting here via OmniAuth.config.failure_raise_out_environments)
  end

  def signout
    skip_authorization
    reset_session
    redirect_to build_logout_url
  end

  private
  def build_logout_url
    request_params = {
        returnTo: root_url,
        client_id: Rails.application.credentials.auth0[:client_id]
    }

    URI::HTTPS.build(host: Rails.application.credentials.auth0[:domain], path: '/v2/logout', query: request_params.to_query).to_s
  end
end
