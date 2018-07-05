class ChargeBeeWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_after_action :verify_authorized
  before_action :authenticate
  
  def consume
    if ["subscription_changed"].include? params[:event_type]
      subscription = ChargeBee::Subscription.retrieve(params[:content][:subscription][:id]).subscription
      Subscription.find_by_chargebee_id(subscription.id).update!(plan: subscription.plan_id, status: subscription.status)
    elsif ["subscription_cancelled"].include? params[:event_type]
      # TODO: Update to a free plan
    end
    
    head :ok
  end

private
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[Rails.env.to_sym][:chargebee][:hook_username] &&
      password == Rails.application.credentials[Rails.env.to_sym][:chargebee][:hook_password]
    end
  end
end