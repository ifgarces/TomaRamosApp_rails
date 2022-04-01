RAMO_EVENT_TYPES = ["CLAS", "AYUD", "LABT", "PRBA", "EXAM"]

if (RamoEventType.count() != RAMO_EVENT_TYPES.count())
    RAMO_EVENT_TYPES.each { |event_type_name|
        RamoEventType.new(name: event_type_name).save()
    }
end

if (AcademicPeriod.order(name: :asc).first() != "2022-10")
    AcademicPeriod.new(name: "2022-10").save()
end
