class User < ApplicationRecord
  has_many :apps

  validates :auth0_id, presence: true

  def admin?
    Rails.env.development? or self.admin
  end
end
