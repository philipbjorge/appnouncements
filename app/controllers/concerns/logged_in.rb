module LoggedIn
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!
    redirect_to root_path unless logged_in?
  end
end
