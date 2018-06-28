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
  
  def self.fix_params params
    params.tap { |p| p[:release] = p[:android_release] || p[:ios_release] }
  end
end
