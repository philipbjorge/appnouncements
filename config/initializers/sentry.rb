Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.current_environment = ENV["HEROKU_ENV"] || ENV["RAILS_ENV"]
end