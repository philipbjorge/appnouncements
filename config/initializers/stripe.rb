Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_api_key]
StripeEvent.signing_secret = Rails.application.credentials[Rails.env.to_sym][:stripe_signing_secret]

StripeEvent.configure do |events|
  update_by_stripe_id = proc { |event| User.update_by_stripe_id(event.data.object.id) }
  
  events.subscribe "customer.updated", update_by_stripe_id
  events.subscribe "customer.subscription.updated", update_by_stripe_id
end