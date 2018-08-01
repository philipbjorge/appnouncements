# == Schema Information
#
# Table name: plans
#
#  id           :bigint(8)        not null, primary key
#  metadata     :json             not null
#  name         :string           not null
#  price        :integer          not null
#  status       :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chargebee_id :string           not null
#

require 'rails_helper'

RSpec.describe Plan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
