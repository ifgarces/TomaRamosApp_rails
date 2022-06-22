# Web application user.
#
# @!attribute email
#   @return [String] Registration email. Supposed to be `@miuandes`.
#
# @!attribute username
#   @return [String] So as this servers as a customizable displayable name for the user profile, in
#   case profiles are ever implemented in the future.

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, email: true

  has_many :user_courses_inscriptions, :dependent => :destroy
end
