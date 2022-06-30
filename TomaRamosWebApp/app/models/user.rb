# Web application user.
#
# @!attribute email
#   @return [String] Registration email. Supposed to be `@miuandes`, unless `is_admin`.
#
# @!attribute username
#   @return [String] So as this servers as a customizable displayable name for the user profile, in
#   case profiles are ever implemented in the future.
#
# @!attribute last_activity
#   @return [DateTime] Timestamp of the last activity of the user, for usage analytics.
#
# @!attribute is_admin
#   @return [Boolean] Wether the user has admin privileges.

class User < ApplicationRecord
  has_secure_password #!
  validates :email, presence: true, uniqueness: true, email: true

  has_many :user_courses_inscriptions, dependent: :destroy
end
