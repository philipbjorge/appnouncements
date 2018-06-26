class IosRelease < Release
  validates :version,
            format: { with: /\A(\d+\.)?(\d+\.)?(\d+)\z/, message: "must match iOS Version requirements"}

  def ios?
    true
  end
end