require "time"
require "date"
require "csv"
require "json"
require "logger"
require "enums/day_of_week_enum"
require "enums/event_type_enum"
require "utils/logging_util"

module CsvDataImporter
  private

  CSV_TIME_SEPARATOR = "-"

  # Mapping each column of the CSV file
  CsvColumns = OpenStruct.new(
    :planEstudios => 0,
    :nrc => 1,
    :conectorLiga => 2,
    :listaCruzada => 3,
    :materia => 4,
    :númeroCurso => 5,
    :sección => 6,
    :nombre => 7,
    :créditos => 8,
    :lunes => 9,
    :martes => 10,
    :miércoles => 11,
    :jueves => 12,
    :viernes => 13,
    :fechaInicio => 15,
    :fechaFin => 16,
    :sala => 17,
    :tipoEvento => 18,
    :profesor => 19
  )

  # Helper class for parsing rows from the CSV
  class CsvRow
    attr_reader :pe, :nrc, :conectorLiga, :listaCruzada, :materia, :curso, :sección, :nombre,
                :créditos, :lunes, :martes, :miércoles, :jueves, :viernes, :fechaInicio, :fechaFin,
                :sala, :tipoEvento, :profesor

    # @param rowCells [Array<String>]
    def initialize(rowCells)
      @pe = rowCells[CsvColumns.planEstudios] # String | nil
      @nrc = rowCells[CsvColumns.nrc].to_i() # Integer
      @conectorLiga = rowCells[CsvColumns.conectorLiga] # String | nil
      @listaCruzada = rowCells[CsvColumns.listaCruzada] # String | nil
      @materia = rowCells[CsvColumns.materia] # String | nil
      @curso = rowCells[CsvColumns.númeroCurso].to_i() # Integer
      @sección = rowCells[CsvColumns.sección] # String | nil
      @nombre = rowCells[CsvColumns.nombre] # String | nil
      @créditos = rowCells[CsvColumns.créditos] # String | nil
      @lunes = CsvRow.parseTimeInterval(rowCells[CsvColumns.lunes]) # Array<Time, Time> | nil
      @martes = CsvRow.parseTimeInterval(rowCells[CsvColumns.martes])
      @miércoles = CsvRow.parseTimeInterval(rowCells[CsvColumns.miércoles])
      @jueves = CsvRow.parseTimeInterval(rowCells[CsvColumns.jueves])
      @viernes = CsvRow.parseTimeInterval(rowCells[CsvColumns.viernes])
      @fechaInicio = CsvRow.parseDate(rowCells[CsvColumns.fechaInicio]) # Date | nil
      @fechaFin = CsvRow.parseDate(rowCells[CsvColumns.fechaFin]) # Date | nil
      @sala = rowCells[CsvColumns.sala] # String | nil
      @tipoEvento = rowCells[CsvColumns.tipoEvento].tr("0-9", "").strip() # String, ignoring digits (e.g. "PRBA 1" => "PRBA")
      @profesor = rowCells[CsvColumns.profesor] # String | nil

      # Ensuring mandatory fields are not null
      [@pe, @nrc, @materia, @sección, @nombre, @tipoEvento, @profesor].each do |field|
        raise "One of the mandatory fields is nil for CsvRow %s" % [self] unless (field != nil)
      end
    end

    # @param cellValue [String | nil] In format "HH:mm - HH:mm"
    # @raise [ArgumentError]
    # @return [Array<Time, Time>] of size 2 for initial and end times
    def self.parseTimeInterval(cellValue)
      if (cellValue == nil)
        return nil
      end
      cleanSplit = cellValue.split(CSV_TIME_SEPARATOR).map { |str|
        str.strip()
      }
      raise ArgumentError.new(
        "Invalid cell value '#{cellValue}': does not have the expected format 'HH:mm - HH:mm'"
      ) unless (cleanSplit.count() == 2)
      return [Time.parse(cleanSplit.first()), Time.parse(cleanSplit.last())]
    end

    # @param cellValue [String | nil] In format "DD/mm/yyyy", could be `nil` for recurrent events
    # such as classes (non-evaluation)
    def self.parseDate(cellValue)
      if (cellValue == nil)
        return nil
      end
      return DateTime.parse(cellValue).to_date()
    end

    def to_s()
      return self.to_json()
    end
  end

  public

  # @param csvFilePath [String]
  # @param academicPeriod AcademicPeriod
  # @return [Array<Object>] A pair with courses `Array<CourseInstance>` and mapping of events
  #   `Hash<Integer, Array<CourseEvent>>`
  def self.import(csvFilePath, academicPeriod)
    log = LoggingUtil.getStdoutLogger(__FILE__)

    # Mapping CSV cell values for actual indexed event type in database
    csvEventTypesMapping = {
      "CLAS" => EventType.find_by(name: EventTypeEnum::CLASS),
      "AYUD" => EventType.find_by(name: EventTypeEnum::ASSISTANTSHIP),
      "LABT" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "TUTR" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "PRBA" => EventType.find_by(name: EventTypeEnum::TEST),
      "EXAM" => EventType.find_by(name: EventTypeEnum::EXAM)
    }

    raise RuntimeError.new(
      "Huh? CourseEvent table should be cleared before processing CSV for events..."
    ) unless (academicPeriod.getCourseEvents().count() == 0)

    # Now parsing the CSV and populating database tables `CourseInstance` and `CourseEvent`
    log.info("Reading courses from CSV '%s' for current AcademicPeriod '%s'..." % [
      csvFilePath, academicPeriod.name
    ])

    if (!File.exist?(csvFilePath))
      log.error("CSV file '%s' does not exist" % [csvFilePath])
      exit(1)
    end

    csvRows = CSV.read(csvFilePath)
    csvRows.delete_at(0) # ignoring CSV headers
    csvRows = csvRows.map { |row|
      row.map { |item|
        (item == nil) ? nil : item.strip()
      }
    }

    gotCourses = [] # :Array<CourseInstances>
    nrcEventsMapping = {} # :Hash<Integer, Array<CourseEvent>>

    allCoursesNRCs = [] # :Array<String>, for small optimization
    csvRows.each_with_index do |row, rowIndex|
      #// log.debug("Processing row %s" % [row])
      parsedRow = CsvRow.new(row)

      if (!allCoursesNRCs.include?(parsedRow.nrc))
        allCoursesNRCs.append(parsedRow.nrc)

        course = CourseInstance.find_by(nrc: parsedRow.nrc, academic_period: academicPeriod) # updating `CourseInstance`s in database, if needed
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
              rowIndex + 2, parsedRow.tipoEvento, csvEventTypesMapping.values()
            ]
          ) unless (eventType != nil)

          if (!nrcEventsMapping.keys().include?(parsedRow.nrc))
            nrcEventsMapping[parsedRow.nrc] = []  
          end
          nrcEventsMapping[parsedRow.nrc].append(
            CourseEvent.new(
              location: parsedRow.sala,
              day_of_week: DayOfWeekEnum.parseStringDay(dayOfWeek),
              start_time: eventTimes.first(),
              end_time: eventTimes.second(),
              date: parsedRow.fechaInicio,
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
    end

    return [gotCourses, nrcEventsMapping]
  end
end
