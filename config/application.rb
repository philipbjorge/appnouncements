require_relative 'boot'

require "rails"

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Appnouncements
  class Application < Rails::Application
    config.load_defaults 5.2
    config.generators.javascript_engine = :js
    config.autoload_paths += %W["#{config.root}/app/validators/" "#{config.root}/app/services/"]
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
