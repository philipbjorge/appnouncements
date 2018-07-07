module BillingsHelper
  def stripe_billing_button_label(customer)
    return "Update Billing Information" if customer&.default_source
    return "Add Billing Information"
  end
  
  def checkout_button_text
    return "Sign up" if current_user.subscription.plan == "free"
    return "Switch"
  end
end
