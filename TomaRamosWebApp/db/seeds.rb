log = Rails.logger

COURSE_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

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
    AcademicPeriod.new(name: AcademicPeriod.getLatestPeriodName()).save!()
  end
end

setEventTypes(log)
setCurrentAcademicPeriod(log)

log.info("Seeds complete ✔️")
