class User < ApplicationRecord
  has_many :apps

  validates :auth0_id, presence: true
end
