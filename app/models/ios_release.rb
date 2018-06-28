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

class IosRelease < Release
  validates :version,
            format: { with: /\A(\d+\.)?(\d+\.)?(\d+)\z/, message: "must match iOS Version requirements"}

  def ios?
    true
  end
end
