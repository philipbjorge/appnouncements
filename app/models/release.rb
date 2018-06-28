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

class Release < ApplicationRecord
  belongs_to :app

  validates :version, presence: true
  validates :title, presence: true
  validates :body, presence: true

  default_scope { order(Arel.sql("string_to_array(version, '.')::int[] DESC")) }
  scope :published, -> { where(published: true) }
  
  def ios?
    false
  end

  def android?
    false
  end
  
  def self.fix_params params, platform
    params.tap { |p| p[:release] = p[release_key(platform)] }
    params.delete(release_key(platform))
    params
  end
  
  def self.release_key platform
    return :android_release if platform == :android
    return :ios_release if platform == :ios
  end
end
