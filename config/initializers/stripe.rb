Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_api_key]
StripeEvent.signing_secret = Rails.application.credentials[Rails.env.to_sym][:stripe_signing_secret]