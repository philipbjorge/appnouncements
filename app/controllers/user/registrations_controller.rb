# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  layout "settings", only: [:edit]
end
