class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, email: true

  has_many :user_courses_inscriptions, :dependent => :destroy
end
