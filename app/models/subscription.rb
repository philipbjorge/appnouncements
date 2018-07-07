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
  before_save :handle_plan_change
  
  def can_create_new_app?
    return (user.apps.count + 1) < app_limit
  end
  
  def show_branding?
    free?
  end

  def app_limit
    return 1 if ["free", "core"].include? plan
    return Float::INFINITY
  end

  def free?
    plan == "free"
  end
  
  def reload_from_chargebee!
    subscription = ChargeBee::Subscription.retrieve(self.chargebee_id).subscription
    self.update!(plan: subscription.plan_id, status: subscription.status)
  end
  
private
  def handle_plan_change
    return unless will_save_change_to_plan?
    
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
