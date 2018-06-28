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

class AndroidRelease < Release
  validates :display_version, presence: true
  validates :version,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2100000000}

  def android?
    true
  end
end
