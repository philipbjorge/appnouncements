# == Schema Information
#
# Table name: releases
#
#  id              :bigint(8)        not null, primary key
#  body            :text             not null
#  display_version :string
#  published       :boolean          default(FALSE)
#  title           :string           not null
#  type            :string           not null
#  version         :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  app_id          :bigint(8)
#
# Indexes
#
#  index_releases_on_app_id  (app_id)
#
# Foreign Keys
#
#  fk_rails_...  (app_id => apps.id)
#

require 'rails_helper'

RSpec.describe AndroidRelease, type: :model do
  it_behaves_like "Release"
  
  it { should validate_presence_of(:display_version) }
  it { should validate_numericality_of(:version).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(2100000000) }
  it { expect(AndroidRelease.new.android?).to be true }
  it { expect(AndroidRelease.new.ios?).to be false }
end
