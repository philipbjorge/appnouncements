# == Schema Information
#
# Table name: subscriptions
#
#  id           :bigint(8)        not null, primary key
#  plan         :string
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chargebee_id :string
#  user_id      :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_chargebee_id  (chargebee_id) UNIQUE
#  index_subscriptions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Subscription < ApplicationRecord
  belongs_to :user
  
  def free?
    plan == "free"
  end
  
  def reload_from_chargebee!
    subscription = ChargeBee::Subscription.retrieve(self.chargebee_id).subscription
    self.update!(plan: subscription.plan_id, status: subscription.status)
  end
end
