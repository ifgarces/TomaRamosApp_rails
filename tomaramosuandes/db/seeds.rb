#! ---
#! DEPRECATED
#! ---

require_relative "../lib/utils/catalog_status"

COURSE_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

if (CourseEventType.count() != COURSE_EVENT_TYPES.count())
    puts("Inserting CourseEvents into database")
    COURSE_EVENT_TYPES.each do |event_type_name|
        CourseEventType.new(name: event_type_name).save()
    end
end

if (CatalogStatus.get_academic_period() == nil)
    puts("Inserting current academic period")
    AcademicPeriod.new(name: CatalogStatus::PERIOD_NAME).save()
end
