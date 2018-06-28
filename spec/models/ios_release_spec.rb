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

RSpec.describe IosRelease, type: :model do
  it_behaves_like "Release"
  
  it { should allow_values("1", "1.1", "1.1.1", "1.10000", "1.10000.1").for(:version) }
  it { should_not allow_values("a", "1.a", "1.", ".1", "a.1", "1.10000.1.5").for(:version) }
  it { expect(IosRelease.new.ios?).to be true }
  it { expect(IosRelease.new.android?).to be false }
end
