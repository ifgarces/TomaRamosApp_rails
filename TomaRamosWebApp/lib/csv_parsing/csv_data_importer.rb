# require "time"
# require "date"
require "csv"
require "json"
require "logger"
require "date"
require "time"
require "utils/logging_util"
require "csv_parsing/csv_row"
require "enums/day_of_week_enum"
require "enums/event_type_enum"

module CsvDataImporter

  # @param csvPath [String]
  # @param csvHeaderSize [Integer] Amount of rows to ignore at first (sheet headers)
  # @param academicPeriod [AcademicPeriod]
  # @return [Array] A pair with courses `Array<CourseInstance>` and mapping of events
  #   `Hash<Integer, Array<CourseEvent>>` where the hash key is the NRC of the course the events
  #   (value) belong to
  def self.import(csvPath:, csvHeaderSize:, academicPeriod:)
    log = LoggingUtil.getStdoutLogger(__FILE__)

    raise TypeError.new(
      "csvPath is of type #{csvPath.class}, not String"
    ) unless (csvPath.is_a?(String))

    raise TypeError.new(
      "csvHeaderSize is of type #{csvHeaderSize.class}, not Integer"
    ) unless (csvHeaderSize.is_a?(Integer))

    raise TypeError.new(
      "academicPeriod is of type #{academicPeriod.class}, not AcademicPeriod"
    ) unless (academicPeriod.is_a?(AcademicPeriod))

    # Mapping CSV cell values for actual indexed event type in database
    csvEventTypesMapping = {
      "CLAS" => EventType.find_by(name: EventTypeEnum::CLASS),
      "AYUD" => EventType.find_by(name: EventTypeEnum::ASSISTANTSHIP),
      "LABT" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "TUTR" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "PRBA" => EventType.find_by(name: EventTypeEnum::TEST),
      "EXAM" => EventType.find_by(name: EventTypeEnum::EXAM)
    }

    # raise RuntimeError.new(
    #   "Huh? CourseEvent table should be cleared before processing CSV for events..."
    # ) unless (academicPeriod.getCourseEvents().count() == 0)

    # Now parsing the CSV and populating database tables `CourseInstance` and `CourseEvent`
    log.info("Reading courses from CSV '%s' for current AcademicPeriod '%s'..." % [
      csvPath, academicPeriod.name
    ])

    if (!File.exist?(csvPath))
      log.error("CSV file '%s' does not exist" % [csvPath])
      exit(1)
    end

    csvRows = CSV.read(csvPath, encoding: "utf-8")

    # Ignoring CSV headers
    csvHeaderSize.times do
      csvRows.delete_at(0)
    end

    csvRows = csvRows.map { |row|
      row.map { |item|
        (item == nil) ? nil : item.strip()
      }
    }

    gotCourses = [] # :Array<CourseInstances>
    nrcEventsMapping = {} # :Hash<Integer, Array<CourseEvent>>

    allCoursesNRCs = [] # :Array<String>, for small optimization
    csvRows.each_with_index do |row, rowIndex|
      begin
        parsedRow = CsvRow.new(row)

        if (!allCoursesNRCs.include?(parsedRow.nrc))
          allCoursesNRCs.append(parsedRow.nrc)

          # Updating CourseInstances in database, if needed (preserving existing relations with
          # Inscriptions)
          course = CourseInstance.find_by(nrc: parsedRow.nrc, academic_period: academicPeriod)
          mustAppend = false
          if (course == nil)
            course = CourseInstance.new(nrc: parsedRow.nrc)
            mustAppend = true
          end

          course.title = parsedRow.nombre
          course.teacher = parsedRow.profesor
          course.credits = parsedRow.créditos
          course.career = parsedRow.materia
          course.course_number = parsedRow.curso
          course.section = parsedRow.sección
          course.curriculum = parsedRow.pe
          course.liga = parsedRow.conectorLiga
          course.lcruz = parsedRow.listaCruzada
          course.academic_period = academicPeriod

          if (mustAppend)
            gotCourses.append(course)
          end
        end

        eventTimeExists = false

        { # :Hash<DayOfWeekEnum, Array<Time, Time> | nil>
          DayOfWeekEnum::MONDAY => parsedRow.lunes,
          DayOfWeekEnum::TUESDAY => parsedRow.martes,
          DayOfWeekEnum::WEDNESDAY => parsedRow.miércoles,
          DayOfWeekEnum::THURSDAY => parsedRow.jueves,
          DayOfWeekEnum::FRIDAY => parsedRow.viernes
        }.each do |dayOfWeek, eventTimes|
          if (eventTimes != nil)
            eventTimeExists = true
            eventType = csvEventTypesMapping[parsedRow.tipoEvento]
            raise RuntimeError.new(
              "CSV parsing error at line %d: invalid event type value '%s', must be one of %s" % [
                rowIndex + 2, parsedRow.tipoEvento, csvEventTypesMapping.keys()
              ]
            ) unless (eventType != nil)

            if (!nrcEventsMapping.keys().include?(parsedRow.nrc))
              nrcEventsMapping[parsedRow.nrc] = []
            end

            # Note: cannot directly save the dates/times as, apparently, the machine's timezone is
            # used instead of UTC, so we have to force it to be timezone-less (set all to UTC) by
            # explicitly creating a new `Date`/`Time` object. I lost quite a lot of time because
            # thanks to it.
            nrcEventsMapping[parsedRow.nrc].append(
              CourseEvent.new(
                location: parsedRow.sala,
                day_of_week: DayOfWeekEnum.parseStringDay(dayOfWeek),
                start_time: Time.utc(2000, 1, 1, eventTimes.first().hour, eventTimes.first().min), #// eventTimes.first().utc,
                end_time: Time.utc(2000, 1, 1, eventTimes.last().hour, eventTimes.last().min), #// eventTimes.last().utc,
                date: (parsedRow.fechaInicio == nil) ? nil : Date.new(parsedRow.fechaInicio.year, parsedRow.fechaInicio.mon, parsedRow.fechaInicio.day), #// parsedRow.fechaInicio,
                course_instance: course,
                event_type: eventType
              )
            )
          end
        end

        if (!eventTimeExists)
          # Just warning, as some cases are valid, like practices
          log.warn(
            "CSV row #%d: no time interval given for this event >> %s" % [rowIndex + 2, row]
          )
        end
      rescue Exception => e
        log.fatal("Exception ocurred while parsing line #{rowIndex + 2}: #{row}")
        log.error("<<< Exception begin >>>")
        log.error("Error type: #{e.class}")
        log.error("Error message: #{e.message}")
        log.error("Backtrace:\n#{e.backtrace.join("\n")}")
        log.error("<<< Exception end >>>")
        raise e
      end
    end

    return [gotCourses, nrcEventsMapping]
  end
end
