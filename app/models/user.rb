class User < ActiveRecord::Base
  has_secure_password
  validates :username :presence, :uniqueness true

  has_many :chores
end
