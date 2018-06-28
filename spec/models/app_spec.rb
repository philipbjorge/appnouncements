# == Schema Information
#
# Table name: apps
#
#  id           :bigint(8)        not null, primary key
#  color        :string           default("#727e96")
#  css          :string
#  disabled     :boolean          default(FALSE)
#  display_name :string
#  platform     :string
#  uuid         :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint(8)
#
# Indexes
#
#  index_apps_on_user_id  (user_id)
#  index_apps_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe App, type: :model do
  # allowed_platforms
  it { should validate_presence_of(:display_name) }
  it { should validate_presence_of(:platform) }
  it { should validate_inclusion_of(:platform).in_array(App.allowed_platforms) }
  it { should validate_presence_of(:color) }
  it { should allow_value("#FFFFFF", "#FFF", "#000", "#F0F0F0").for(:color) }
  it { should_not allow_value("DodgerBlue", "rgb(255, 99, 71)", "hsl(9, 100%, 64%)", "rgba(255, 99, 71, 0.5)", "hsla(9, 100%, 64%, 0.5)").for(:color) }
  it { should belong_to(:user) }
  it { should have_many(:releases).dependent(:destroy) }

  it { should have_db_index(:user_id) }
  it { should have_db_index(:uuid) }
end
