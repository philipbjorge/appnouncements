# == Schema Information
#
# Table name: apps
#
#  id           :bigint(8)        not null, primary key
#  display_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint(8)
#  uuid         :uuid
#  color        :string           default("#727e96")
#  css          :string
#  platform     :string
#  disabled     :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe App, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
