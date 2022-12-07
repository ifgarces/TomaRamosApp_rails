require "logger"
require "figaro"
require "date"
require "utils/logging_util"
require "enums/event_type_enum"

ADMIN_USER_EMAIL = "admin@tomaramos.app"

@log = LoggingUtil.getStdoutLogger(__FILE__)

# @param name [String]
# @return [nil]
# @raise [ArgumentError] In case the environment variable does not exist
def assertEnvExists(name)
  raise ArgumentError.new(
    "Environment variable '#{name}' is not defined"
  ) unless (ENV[name] != nil) && (!ENV[name].blank?)
end

# If an error triggers here, you have to fill your `.secrets.env` properly with stuff for Google
# Cloud (for the Oauth2 button). This assert is just to ensure these are defined for the web
# server, not needed on this file
#! Disabled for now as Oauth is not yet implemented
# assertEnvExists("OAUTH_CLIENT_ID")
# assertEnvExists("OAUTH_CLIENT_SECRET")

def createAdminUser()
  assertEnvExists("ADMIN_USER_PASSWORD")

  adminPassword = ENV["ADMIN_USER_PASSWORD"]

  adminUser = User.find_by(email: ADMIN_USER_EMAIL)
  if (adminUser.nil?)
    adminUser = User.new(email: ADMIN_USER_EMAIL)
  end

  adminUser.username = "admin"
  adminUser.password = adminPassword
  adminUser.is_admin = true

  adminUser.save!()
end

def createEventTypes()
  courseEventTypes = [
    EventTypeEnum::CLASS,
    EventTypeEnum::ASSISTANTSHIP,
    EventTypeEnum::LABORATORY,
    EventTypeEnum::TEST,
    EventTypeEnum::EXAM
  ]
  if (EventType.count() != courseEventTypes.count())
    @log.debug("Inserting CourseEvents into database")
    EventType.all().each do |prevEventTypes|
      prevEventTypes.destroy!()
    end
    courseEventTypes.each do |event_type_name|
      EventType.new(name: event_type_name).save!()
    end
  end
end

def setCurrentAcademicPeriod()
  if (AcademicPeriod.getLatest().nil?)
    @log.debug("Inserting current academic period '#{AcademicPeriod.getLatestPeriodName()}'")
    AcademicPeriod.new(
      name: AcademicPeriod.getLatestPeriodName()
    ).save!()
  end
end

createAdminUser()
createEventTypes()
setCurrentAcademicPeriod()

@log.info("✔️ Seeds complete")
