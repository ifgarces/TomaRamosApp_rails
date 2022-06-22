require_relative "../lib/utils/catalog_status"

RAMO_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

if (RamoEventType.count() != RAMO_EVENT_TYPES.count())
    puts("Inserting RamoEvents into database")
    RAMO_EVENT_TYPES.each do |event_type_name|
        RamoEventType.new(name: event_type_name).save()
    end
end

if (CatalogStatus.get_academic_period() == nil)
    puts("Inserting current academic period")
    AcademicPeriod.new(name: CatalogStatus::PERIOD_NAME).save()
end
