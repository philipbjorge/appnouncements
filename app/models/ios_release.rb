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

class IosRelease < Release
  validates :version,
            format: { with: /\A(\d+\.)?(\d+\.)?(\d+)\z/, message: "must match iOS Version requirements"}

  def ios?
    true
  end
end
