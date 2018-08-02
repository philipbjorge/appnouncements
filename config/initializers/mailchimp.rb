if Rails.env.production?
  Gibbon::Request.api_key = Rails.application.credentials[:production][:mailchimp][:api_key]
  Gibbon::Request.timeout = 5
  Gibbon::Request.open_timeout = 5
end