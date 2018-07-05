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

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
