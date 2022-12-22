require "logger"
require "date"
require "utils/logging_util"
require "enums/event_type_enum"

ADMIN_USER_EMAIL = "admin@tomaramos.app"

@log = LoggingUtil.getStdoutLogger(__FILE__)

# @return [nil]
def createAdminUser()
  adminPassword = ENV.fetch("ADMIN_USER_PASSWORD")

  adminUser = User.find_by(email: ADMIN_USER_EMAIL)
  if (adminUser.nil?)
    adminUser = User.new(email: ADMIN_USER_EMAIL)
  end

  adminUser.username = "admin"
  adminUser.password = adminPassword
  adminUser.is_admin = true

  adminUser.save!()
end

# @return [nil]
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

# @return [nil]
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
