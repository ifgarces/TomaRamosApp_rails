require "logger"
require "date"
require "utils/logging_util"
require "enums/event_type_enum"

@log = LoggingUtil.getStdoutLogger(__FILE__)

# @return [nil]
# def createSuperAdminUser() #! Unused
#   adminEmail = ENV.fetch("ADMIN_EMAIL") { "admin@tomaramos.app" }
#   superAdmin = User.find_by(email: adminEmail)
#   if (superAdmin.nil?)
#     superAdmin = User.new(email: adminEmail)
#   end
#   superAdmin.username = ENV.fetch("ADMIN_USERNAME") { "admin" }
#   superAdmin.password = ENV.fetch("ADMIN_PASSWORD")
#   superAdmin.is_admin = true
#   superAdmin.save!()
# end

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

# If a new period was set (i.e. AcademicPeriod.LATEST_PERIOD_NAME was changed by code)
# @return [nil]
def setCurrentAcademicPeriod()
  if (AcademicPeriod.getLatest().nil?)
    @log.debug("Inserting current academic period '#{AcademicPeriod.getLatestPeriodName()}'")
    AcademicPeriod.new(
      name: AcademicPeriod.getLatestPeriodName()
    ).save!()
  end
end

createEventTypes()
setCurrentAcademicPeriod()

@log.info("[OK] Seeds complete")
