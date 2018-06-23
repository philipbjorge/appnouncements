class BillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :skip_authorization
  
  layout "settings"
  
  def show
    @customer = current_user.customer
    @invoices = Stripe::Invoice.list(limit: 30, customer: @customer.id).data.select {|i| i.hosted_invoice_url } if @customer
  end
  
  def update
    # Defer creating our stripe customer until we have billing info to keep our DB clean
    current_user.create_or_update_stripe_customer! params.require(:stripeToken), params.require(:stripeEmail)
    redirect_to billing_path, notice: "Billing information successfully updated!"
  end
end