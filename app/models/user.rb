class User < ApplicationRecord
  
  def self.update_by_stripe_id(stripe_id)
    user = User.find_by_stripe_id(stripe_id)
    (logger.error("Unable to find user with stripe id #{stripe_id}") and return) unless user
    
    customer = Stripe::Customer.retrieve({id: stripe_id, expand: ["default_source"]})
    user.stripe_customer = customer.as_json
    raise "More subscriptions need to be fetched" if customer.subscriptions.has_more
    user.save!
  end
  
  def self.clear_stripe_id(stripe_id)
    user = User.find_by_stripe_id(stripe_id)
    return unless user
    
    user.stripe_id = nil
    user.stripe_customer = nil
    user.save!
  end
  
  devise :database_authenticatable, :registerable, :recoverable,
                  :rememberable, :trackable, :validatable, :confirmable, :lockable,
                  send_email_changed_notification: true, send_password_change_notification: true,
                  allow_unconfirmed_access_for: 7.days, reconfirmable: true,
                  reset_password_within: 1.hour, sign_in_after_reset_password: true,
                  extend_remember_period: true,
                  unlock_strategy: :email, lock_strategy: :failed_attempts, maximum_attempts: 10

  has_many :apps, dependent: :destroy
  
  # TODO: Handle disabling stuff and resuming unpaid subscription
  # TODO: On destroy, unsubscribe from Stripe!
  
  def customer
    Stripe::Util.convert_to_stripe_object(self.stripe_customer)
  end
  
  def customer=(v)
    self.stripe_id = v.id
    self.stripe_customer = v.as_json
  end
  
  def require_billing_information?
    self.customer&.default_source.nil? and self.apps.length >= 1
  end

  def require_updated_billing_information?
    self.customer&.delinquent and self.apps.length >= 1
  end
  
  def create_or_update_stripe_customer! token, email
    update_params = {source: token, email: email, description: "id: #{self.id}", expand: ["default_source"]}
    
    if self.customer
      self.customer = Stripe::Customer.update(self.customer.id, update_params)
    else
      self.customer = Stripe::Customer.create(update_params)
    end
    
    self.save!
  end
end
