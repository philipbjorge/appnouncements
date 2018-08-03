# == Schema Information
#
# Table name: subscriptions
#
#  id           :bigint(8)        not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chargebee_id :string
#  plan_id      :bigint(8)
#  user_id      :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_chargebee_id  (chargebee_id) UNIQUE
#  index_subscriptions_on_plan_id       (plan_id)
#  index_subscriptions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#  fk_rails_...  (user_id => users.id)
#

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  
  before_save :handle_plan_change
  
  delegate :show_branding?, :app_limit, to: :plan
  
  def reload_from_chargebee!
    subscription = ChargeBee::Subscription.retrieve(self.chargebee_id).subscription
    self.update!(plan: Plan.find_by!(chargebee_id: subscription.plan_id), status: subscription.status)
  end
  
private
  def handle_plan_change
    return unless will_save_change_to_plan_id?
    
    if user.apps.count > app_limit
      # Ensure any apps under their limit are enabled
      user.apps.left_joins(:releases).group(:id).order('COUNT(releases.id) DESC').limit(user.apps.count - app_limit).update_all(disabled: false)
      # Disable everything else
      user.apps.left_joins(:releases).group(:id).order('COUNT(releases.id) DESC').offset(app_limit).update_all(disabled: true)
    else
      # Enable them
      user.apps.update_all(disabled: false)
    end
  end
end
