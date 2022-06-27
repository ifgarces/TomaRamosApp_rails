require "logger"
require "figaro"

log = Rails.logger

# @param name [String]
# @return [Boolean]
def envExists(name)
  return (ENV[name] != nil) && (!ENV[name].blank?)
end

raise RuntimeError.new(
  "Google Cloud secrets missing! Please fill your `.secrets.env` properly"
) unless (envExists("GCLOUD_CLIENT_ID") && envExists("GCLOUD_PRIVATE_KEY"))

COURSE_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

# @param log [Logger]
def createUserPassword(log)
  raise RuntimeError.new(
    "ADMIN_USER_PASSWORD environment variable was not provided or is blank"
  ) unless envExists("ADMIN_USER_PASSWORD")

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

createUserPassword(log)
setEventTypes(log)
setCurrentAcademicPeriod(log)

log.info("✔️ Seeds complete")
