module BillingsHelper
  def stripe_billing_button_label(customer)
    return "Update Billing Information" if customer.default_source
    return "Add Billing Information"
  end
end
