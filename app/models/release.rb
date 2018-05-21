class Release < ApplicationRecord
  belongs_to :app

  validates :version, presence: true
  validates :title, presence: true
  validates :body, presence: true

  default_scope { order("string_to_array(version, '.')::int[] DESC") }
end
