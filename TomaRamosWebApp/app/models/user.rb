require "date"
require "faker"

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
  has_secure_password #* bcrypt
  validates :email, presence: true, uniqueness: true, email: true

  has_many :user_courses_inscriptions, dependent: :destroy

  GUEST_USER_PREFIX = "guest¬"

  # Updates the `last_activity` attribute with the current `DateTime`
  # @return [nil]
  def updateLastActivity()
    #TODO: make this asynchronous for optimal performance
    self.last_activity = DateTime.now()
    self.save!()
  end

  # @return [Boolean] Whether this user is of type "guest".
  def isGuestUser()
    return self.username.start_with?(GUEST_USER_PREFIX)
  end

  # Used for creating a user from `session` (not yet saved in database).
  # @return [User]
  def self.getNewGuestUser()
    newUsername = self.generateGuestUsername()
    return User.new(
      email: "%s@email.com" % [newUsername],
      username: newUsername,
      password: "qwerty", #* maybe add a `can_log_in` attribute and set to false for guest users?
      last_activity: DateTime.now()
    )
  end

  private

  # @return [String] A unique new guest username.
  def self.generateGuestUsername()
    while (true)
      newUsername = "%s%s" % [GUEST_USER_PREFIX, Faker::Lorem.characters(number: 10)]
      isUnique = User.find_by(username: newUsername).nil?
      if (isUnique)
        return newUsername
      end
    end
  end
end
