class Auth0Controller < ApplicationController
  def callback
    auth_context = request.env['omniauth.auth']
    puts(auth_context)
    session[:user_id] = User.find_or_create_by!(auth0_id: auth_context[:uid]).id
    head :ok, content_type: "text/html"
    #redirect_to '/apps'
  end
end
