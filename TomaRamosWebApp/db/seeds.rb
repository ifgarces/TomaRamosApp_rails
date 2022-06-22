#! ---
#! DEPRECATED
#! ---

COURSE_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

if (EventType.count() != COURSE_EVENT_TYPES.count())
  puts("Inserting CourseEvents into database")
  EventType.all().each { |prevEventTypes|
    prevEventTypes.destroy!()
  }
  COURSE_EVENT_TYPES.each do |event_type_name|
    EventType.new(name: event_type_name).save!()
  end
end

if (AcademicPeriod.getLatest().nil?)
  puts("Inserting current academic period")
  AcademicPeriod.new(name: AcademicPeriod.getLatestPeriodName()).save!()
end

puts("Seeds complete ✔️")
