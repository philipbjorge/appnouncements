class BillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :skip_authorization
  
  layout "settings"
  
  def show
    @customer = current_user.customer
    @invoices = Stripe::Invoice.list(limit: 30, customer: @customer.id).data.select {|i| i.hosted_invoice_url }
  end
  
  def update
    current_user.customer = Stripe::Customer.update(current_user.customer.id, {source: params.require(:stripeToken),
                                                                               email: params.require(:stripeEmail),
                                                                               expand: ["default_source"]})
    current_user.save!
    redirect_to billing_path, notice: "Billing information successfully updated!"
  end
end