# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  stripe_customer        :json
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_id              :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_stripe_id             (stripe_id) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

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
                  :rememberable, :trackable, :validatable, :confirmable, 
                  send_email_changed_notification: true, send_password_change_notification: true,
                  allow_unconfirmed_access_for: 7.days, reconfirmable: true,
                  reset_password_within: 1.hour, sign_in_after_reset_password: true,
                  extend_remember_period: true

  has_many :apps, dependent: :destroy

  validates_acceptance_of :terms_of_service, on: :create
  
  # TODO: Handle disabling stuff and resuming unpaid subscription
  # TODO: On destroy, unsubscribe from Stripe!
  
  def customer
    Stripe::Util.convert_to_stripe_object(self.stripe_customer)
  end
  
  def customer=(v)
    self.stripe_id = v.id
    self.stripe_customer = v.as_json
  end
  
  def needs_billing_info?
    self.customer&.default_source.nil? || self.customer&.delinquent
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
