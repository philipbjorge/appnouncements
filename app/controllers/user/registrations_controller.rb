# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  layout "settings", only: [:create, :edit, :update]

  def after_update_path_for(resource)
    edit_profile_path()
  end
end
