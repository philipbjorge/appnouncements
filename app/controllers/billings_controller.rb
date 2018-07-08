class BillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :skip_authorization
  
  layout "settings"
  
  def show
    @subscription = current_user.subscription
  end
  
  def hosted_page
    result = ChargeBee::HostedPage.checkout_existing(subscription: {:id => current_user.subscription.chargebee_id, plan_id: params[:plan_id] }, embed: false)
    render json: result.hosted_page.to_s
  end
  
  def portal_session
    result = ChargeBee::PortalSession.create(customer: {:id => current_user.chargebee_id }, embed: false)
    render json: result.portal_session.to_s
  end
  
  def update
    current_user.subscription.reload_from_chargebee!
    redirect_to billing_path
  end
end