# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  layout "settings", only: [:edit, :update]
  before_action :permit_signup_params

  def after_update_path_for(resource)
    edit_profile_path()
  end

private
  def permit_signup_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:tos_pp])
  end
end
