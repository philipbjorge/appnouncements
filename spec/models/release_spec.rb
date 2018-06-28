# == Schema Information
#
# Table name: releases
#
#  id              :bigint(8)        not null, primary key
#  type            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string           not null
#  body            :text             not null
#  app_id          :bigint(8)
#  published       :boolean          default(FALSE)
#  version         :string           not null
#  display_version :string
#

require 'rails_helper'

RSpec.describe Release, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
