class BillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :skip_authorization
  
  layout "settings"
  
  def show
    # Super Dirty Hack
    current_user.subscription.reload_from_chargebee!
    @hosted_page = ChargeBee::HostedPage.checkout_existing(subscription: {:id => current_user.subscription.chargebee_id, plan_id: "core-unlimited" }, embed: false).hosted_page if current_user.subscription.plan == "free"
    @portal = ChargeBee::PortalSession.create(customer: {:id => current_user.chargebee_id }, embed: false).portal_session unless current_user.subscription.plan == "free"
  end
end