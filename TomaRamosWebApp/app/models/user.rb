require "date"
require "faker"
require "utils/events_conflict"

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

  has_many :inscriptions, dependent: :destroy

  GUEST_EMAIL_DOMAIN = "guest-user.com"

  # @return [Array<CourseInstance>]
  def getInscribedCourses()
    return self.inscriptions.first().course_instances
  end

  # @return [Integer] The total amount of credits inscribed by the user
  def computeCredits()
    return self.getInscribedCourses().map { |course|
      course.credits
    }.sum()
  end

  # @param course [CourseInstance]
  # @return [nil]
  def inscribeNewCourse(course)
    raise RuntimeError.new(
      "For now, there should be a single Inscription for each user (not #{self.inscriptions.count()})"
    ) unless (self.inscriptions.count() == 1)

    self.inscriptions.first().course_instances.append(course)
    self.save!()
  end

  # @param course [CourseInstance]
  # @return [nil]
  def uninscribeCourse(course)
    self.inscriptions.first().course_instances = []
    self.save!()
  end

  # @param newCourse [CourseInstance]
  # @return [Array<EventsConflict>] Computed conflicts between events, checking the current
  # inscribed courses by the user, and a target course
  def getConflictsForNewCourse(newCourse)
    allConflicts = []

    self.getInscribedCourses().each do |currentCourse|
      allConflicts.concat(
        CourseInstance.getConflictsBetween(currentCourse, newCourse)
      )
    end

    return allConflicts
  end

  # Updates the `last_activity` attribute with the current `DateTime`
  # @return [nil]
  def updateLastActivity()
    #TODO: make this asynchronous for optimal performance
    self.last_activity = DateTime.now()
    self.save!()
  end

  # @return [Boolean] Whether this user is of type "guest".
  def isGuestUser()
    return self.email.end_with?(GUEST_EMAIL_DOMAIN)
  end

  # Generates a new guest User (intended for `session`), saves it in database, and returns it. 
  # @return [User]
  def self.createNewGuestUser()
    newUsername = self.generateGuestUsername()
    guestUser = User.new(
      email: "%s@%s" % [newUsername, GUEST_EMAIL_DOMAIN],
      username: newUsername,
      password: "qwerty", #* maybe add a `can_log_in` attribute and set to false for guest users?
      last_activity: DateTime.now()
    )
    guestUser.inscriptions.append(Inscription.new())
    guestUser.save!()
    return guestUser
  end

  private

  # @return [String] A unique new guest username.
  def self.generateGuestUsername()
    while (true)
      newUsername = Faker::Lorem.characters(number: 10)
      isUnique = User.find_by(username: newUsername).nil?
      if (isUnique)
        return newUsername
      end
    end
  end
end
