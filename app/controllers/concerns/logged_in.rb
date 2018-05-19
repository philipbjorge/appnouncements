module LoggedIn
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!
    redirect_to "/auth/auth0" unless logged_in?
  end
end
