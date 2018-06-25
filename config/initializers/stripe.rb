Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_api_key]
StripeEvent.signing_secret = Rails.application.credentials[Rails.env.to_sym][:stripe_signing_secret]

StripeEvent.configure do |events|
  update_by_customer = proc { |event| User.update_by_stripe_id(event.data.object.id) }
  clear_by_customer = proc { |event| User.clear_stripe_id(event.data.object.id) }
  update_by_subscription = proc { |event| User.update_by_stripe_id(event.data.object.customer) }
  
  events.subscribe "customer.updated", update_by_customer
  events.subscribe "customer.deleted", clear_by_customer
  events.subscribe "customer.subscription.created", update_by_subscription
  events.subscribe "customer.subscription.updated", update_by_subscription
  events.subscribe "customer.subscription.deleted", update_by_subscription
end