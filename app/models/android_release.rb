class AndroidRelease < Release
  validates :display_version, presence: true
  validates :version,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2100000000}

  def android?
    true
  end
end