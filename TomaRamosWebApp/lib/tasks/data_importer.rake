require "time"
require "date"
require "csv"
require "json"
require "logger"

require "enums/day_of_week_enum"
require "enums/event_type_enum"
require "utils/logging_util"

log = LoggingUtil.getStdoutLogger(__FILE__, Logger::INFO)

CSV_FILE_PATH = "db/catalog-ing.csv"
CSV_TIME_SEPARATOR = "-"

namespace :data_importer do
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
      @tipoEvento = rowCells[CsvColumns.tipoEvento].tr("0-9", "").strip() # String, ignoring numbers (e.g. "PRBA 1" is treated as just "PRBA")
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

  task csv: :environment do
    desc "
    Imports course data from sheet files (e.g. CSV) for when the faculty performs changes on the
    catalog for the latest `AcademicPeriod`.
    "

    # Mapping CSV cell values for actual indexed event type in database
    csvEventTypesMapping = {
      "CLAS" => EventType.find_by(name: EventTypeEnum::CLASS),
      "AYUD" => EventType.find_by(name: EventTypeEnum::ASSISTANTSHIP),
      "LABT" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "TUTR" => EventType.find_by(name: EventTypeEnum::LABORATORY),
      "PRBA" => EventType.find_by(name: EventTypeEnum::TEST),
      "EXAM" => EventType.find_by(name: EventTypeEnum::EXAM)
    }

    #TODO: instead of deleting everything, update existing records in a smart way

    log.info("Clearing CourseInstance and CourseEvent tables prior to CSV parsing...")
    CourseEvent.delete_all()
    # CourseInstance.delete_all()

    log.info("%d AcademicPeriods existing in database" % [AcademicPeriod.count()])

    currentAcademicPeriod = AcademicPeriod.getLatest()

    # Now parsing the CSV and populating database tables `CourseInstance` and `CourseEvent`
    log.info("Reading courses from CSV '%s' for current AcademicPeriod '%s'..." % [
      CSV_FILE_PATH, currentAcademicPeriod.name
    ])

    if (!File.exist?(CSV_FILE_PATH))
      log.error("CSV file '%s' does not exist" % [CSV_FILE_PATH])
      exit(1)
    end

    csvRows = CSV.read(CSV_FILE_PATH)
    csvRows.delete_at(0) # ignoring CSV headers
    csvRows = csvRows.map { |row|
      row.map { |item|
        (item == nil) ? nil : item.strip()
      }
    }
    allCoursesNRCs = [] # :Array<String>
    csvRows.each_with_index do |row, rowIndex|
      log.debug("Processing row %s" % [row])
      parsedRow = CsvRow.new(row)
      if (!allCoursesNRCs.include?(parsedRow.nrc))
        allCoursesNRCs.append(parsedRow.nrc)

        course = CourseInstance.find_by(nrc: parsedRow.nrc)
        if (course != nil) #! will only work for a given AcademicPeriod!
          log.debug("Course NRC %s exists, updating..." % parsedRow.nrc) #! temp
          course.title = parsedRow.nombre
          course.teacher = parsedRow.profesor
          course.credits = parsedRow.créditos
          course.career = parsedRow.materia
          course.course_number = parsedRow.curso
          course.section = parsedRow.sección
          course.curriculum = parsedRow.pe
          course.liga = parsedRow.conectorLiga
          course.lcruz = parsedRow.listaCruzada
          course.academic_period = currentAcademicPeriod
        else
          course = CourseInstance.new(
            nrc: parsedRow.nrc,
            title: parsedRow.nombre,
            teacher: parsedRow.profesor,
            credits: parsedRow.créditos,
            career: parsedRow.materia,
            course_number: parsedRow.curso,
            section: parsedRow.sección,
            curriculum: parsedRow.pe,
            liga: parsedRow.conectorLiga,
            lcruz: parsedRow.listaCruzada,
            academic_period: currentAcademicPeriod
          )
        end
        course.save!()
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

          CourseEvent.new(
            location: parsedRow.sala,
            day_of_week: DayOfWeekEnum.parseStringDay(dayOfWeek),
            start_time: eventTimes.first(),
            end_time: eventTimes.second(),
            date: parsedRow.fechaInicio,
            course_instance: CourseInstance.find_by(nrc: parsedRow.nrc), #// course_instance: CourseInstance.last(),
            event_type: eventType
          ).save!()
        end
      end

      if (!eventTimeExists)
        # Just warning, as some cases are valid, like practices
        log.warn(
          "CSV row #%d: no time interval given for this event >> %s" % [rowIndex + 2, row]
        )
      end
    end

    log.info("✔️ CSV parsing complete: loaded %d CourseInstances and %d CourseEvents" % [
      CourseInstance.count(), CourseEvent.count()
    ])
  end
end
