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
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  chargebee_id           :string
#
# Indexes
#
#  index_users_on_chargebee_id          (chargebee_id) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable, :recoverable,
                  :rememberable, :trackable, :validatable, :confirmable, 
                  send_email_changed_notification: false, send_password_change_notification: true,
                  allow_unconfirmed_access_for: 7.days, reconfirmable: true,
                  reset_password_within: 6.hours, sign_in_after_reset_password: true,
                  extend_remember_period: true

  has_many :apps, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates_acceptance_of :tos_pp, on: :create
  
  after_create :add_to_mailchimp, if: -> { Rails.env.production? }
  after_create :create_chargebee_customer!
  before_destroy :destroy_chargebee_customer!
  
private
  def create_chargebee_customer!
    return unless chargebee_id.nil?
    
    result = ChargeBee::Subscription.create(plan_id: "free", customer: {cf_rails_id: self.id})
    subscription = result.subscription
    customer = result.customer
    
    self.chargebee_id = customer.id
    self.build_subscription(plan: Plan.find_by!(chargebee_id: subscription.plan_id), status: subscription.status, chargebee_id: subscription.id)
    self.save!
  end
  
  def add_to_mailchimp
    begin
      Gibbon::Request.new().lists("6a41a22ad1").members.create(body: { email_address: self.email, status: "subscribed", double_optin: false })
    rescue Gibbon::MailChimpError => e
      logger.error "Failed to subscribe #{self.email} to MailChimp"
      Raven.capture_exception(e)
    end
  end
  
  def destroy_chargebee_customer!
    ChargeBee::Customer.delete(self.chargebee_id)
  end
end
