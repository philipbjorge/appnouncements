class User < ApplicationRecord
  
  def self.update_by_stripe_id(stripe_id)
    user = User.find_by_stripe_id(stripe_id)
    (logger.error("Unable to find user with stripe id #{stripe_id}") and return) unless user
    
    customer = Stripe::Customer.retrieve({id: stripe_id, expand: ["default_source"]})
    user.stripe_customer = customer.as_json
    raise "More subscriptions need to be fetched" if customer.subscriptions.has_more
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

  before_create :create_stripe_customer
  
  def customer
    @customer ||= Stripe::Util.convert_to_stripe_object(self.stripe_customer)
  end
  
  private
  def create_stripe_customer
    customer = Stripe::Customer.create()
    
    self.stripe_id = customer.id
    self.stripe_customer = customer.as_json
  end
end
