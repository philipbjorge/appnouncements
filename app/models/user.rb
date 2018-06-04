class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
                  :rememberable, :trackable, :validatable, :confirmable, :lockable,
                  send_email_changed_notification: true, send_password_change_notification: true,
                  allow_unconfirmed_access_for: 7.days, reconfirmable: true,
                  reset_password_within: 1.hour, sign_in_after_reset_password: true,
                  extend_remember_period: true,
                  unlock_strategy: :email, lock_strategy: :failed_attempts, maximum_attempts: 10

  has_many :apps, dependent: :destroy

  before_create :create_customer
  
  private
  def create_customer
    self.chargebee_id = (ChargeBee::Customer.create).customer.id
  end
end
