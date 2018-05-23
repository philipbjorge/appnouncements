class Release < ApplicationRecord
  belongs_to :app

  validates :version, presence: true

  # Messes with Simple Forms
  #
  # Android Validation
  validates :version,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2100000000},
            if: :android?

  # iOS Validation
  validates :version,
            format: { with: /\A(\d+\.)?(\d+\.)?(\d+)\z/, message: "must match iOS Version requirements"},
            if: :ios?

  validates :title, presence: true
  validates :display_version, presence: true
  validates :body, presence: true

  default_scope { order(Arel.sql("string_to_array(version, '.')::int[] DESC")) }

  before_validation :set_display_version, if: :ios?

  private
  def ios?
    self.app.platform == "ios"
  end

  def android?
    self.app.platform == "android"
  end

  def set_display_version
    self.display_version = self.version
  end
end
