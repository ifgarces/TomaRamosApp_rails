require "logger"
require "figaro"

require "utils/logging_util"

log = LoggingUtil.getStdoutLogger(__FILE__)

# @param name [String]
# @return [nil]
# @raise [ArgumentError] In case the environment variable does not exist
def assertEnvExists(name)
  raise ArgumentError.new(
    ""
  ) unless (ENV[name] != nil) && (!ENV[name].blank?)
end

# If an error triggers here, you have to fill your `.secrets.env` properly with stuff for Google
# Cloud (for the Oauth2 button). This assert is just to ensure these are defined for the web
# server, not needed on this file
assertEnvExists("OAUTH_CLIENT_ID")
assertEnvExists("OAUTH_CLIENT_SECRET")

COURSE_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

# @param log [Logger]
def createAdminUser(log)
  assertEnvExists("ADMIN_USER_PASSWORD")

  adminPassword = ENV["ADMIN_USER_PASSWORD"]

  User.new(
    email: "admin@tomaramos.app",
    username: "admin",
    password: adminPassword,
    is_admin: true
  ).save!()
end

# @param log [Logger]
def setEventTypes(log)
  if (EventType.count() != COURSE_EVENT_TYPES.count())
    log.debug("Inserting CourseEvents into database")
    EventType.all().each do |prevEventTypes|
      prevEventTypes.destroy!()
    end
    COURSE_EVENT_TYPES.each do |event_type_name|
      EventType.new(name: event_type_name).save!()
    end
  end
end

# @param log [Logger]
def setCurrentAcademicPeriod(log)
  if (AcademicPeriod.getLatest().nil?)
    log.debug("Inserting current academic period")
    AcademicPeriod.new(
      name: AcademicPeriod.getLatestPeriodName()
    ).save!()
  end
end

createAdminUser(log)
setEventTypes(log)
setCurrentAcademicPeriod(log)

log.info("✔️ Seeds complete")
