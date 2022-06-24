#! ---
#! DEPRECATED
#! ---

require "time"
require "date"
require "csv"
require "json"
require "utils/day_of_week"

log = Rails.logger

CSV_FILE_PATH = "db/catalog-ing.csv"
CSV_TIME_SEPARATOR = "-"

namespace :data_importer do
  desc "
    Rake task(s) for importing data from sheet files (e.g. CSV) for when the faculty performs
    changes on the catalog.
    "

  # Retrieves data from the CSV (standard engineering faculty format) and fills the database
  task csv_all: :environment do
    CsvColumns = OpenStruct.new(
      :plan_estudios => 0,
      :nrc => 1,
      :conectorLiga => 2,
      :listaCruzada => 3,
      :materia => 4,
      :número_curso => 5,
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

    # Mapping CSV cell values for actual indexed event type in database
    csvEventTypesHash = {
      "CLAS" => EventType.find_by(name: "CLAS"),
      "AYUD" => EventType.find_by(name: "AYUD"),
      "LABT" => EventType.find_by(name: "LABT"),
      "TUTR" => EventType.find_by(name: "LABT"),
      "PRBA" => EventType.find_by(name: "PRBA"),
      "EXAM" => EventType.find_by(name: "EXAM")
    }

    # Helper class for parsing rows from the CSV
    class CsvRow
      attr_reader :pe, :nrc, :conectorLiga, :listaCruzada, :materia, :curso, :sección, :nombre,
                  :créditos, :lunes, :martes, :miércoles, :jueves, :viernes, :fechaInicio,
                  :fechaFin, :sala, :tipoEvento, :profesor

      # @param row_cells [Array<String>]
      def initialize(row_cells)
        @pe = row_cells[CsvColumns.plan_estudios] # string | nil
        @nrc = row_cells[CsvColumns.nrc].to_i() # integer
        @conectorLiga = row_cells[CsvColumns.conectorLiga] # string | nil
        @listaCruzada = row_cells[CsvColumns.listaCruzada] # string | nil
        @materia = row_cells[CsvColumns.materia] # string | nil
        @curso = row_cells[CsvColumns.número_curso].to_i() # integer
        @sección = row_cells[CsvColumns.sección] # string | nil
        @nombre = row_cells[CsvColumns.nombre] # string | nil
        @créditos = row_cells[CsvColumns.créditos] # string | nil
        @lunes = CsvRow.parseTimeInterval(row_cells[CsvColumns.lunes]) # List[Time] | nil
        @martes = CsvRow.parseTimeInterval(row_cells[CsvColumns.martes]) # List[Time] | nil
        @miércoles = CsvRow.parseTimeInterval(row_cells[CsvColumns.miércoles]) # List[Time] | nil
        @jueves = CsvRow.parseTimeInterval(row_cells[CsvColumns.jueves]) # List[Time] | nil
        @viernes = CsvRow.parseTimeInterval(row_cells[CsvColumns.viernes]) # List[Time] | nil
        @fechaInicio = CsvRow.parseDate(row_cells[CsvColumns.fechaInicio]) # Date | nil
        @fechaFin = CsvRow.parseDate(row_cells[CsvColumns.fechaFin]) # Date | nil
        @sala = row_cells[CsvColumns.sala] # string | nil
        @tipoEvento = row_cells[CsvColumns.tipoEvento].tr("0-9", "").strip() # string, ignoring numbers (e.g. "PRBA 1" is treated as just "PRBA")
        @profesor = row_cells[CsvColumns.profesor] # string | nil

        # Ensuring mandatory fields are not null
        [@pe, @nrc, @materia, @sección, @nombre, @tipoEvento, @profesor].each do |field|
          raise "One of the mandatory fields is nil for CsvRow %s" % [self] unless (field != nil)
        end
      end

      
      # @param cellValue [String | nil] format "HH:mm - HH:mm"
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

    log.info("Clearing CourseInstance and CourseEvent tables prior to CSV parsing...")

    #TODO: only delete data for the current target academic period, not all!
    CourseEvent.delete_all()
    CourseInstance.delete_all()

    currentAcademicPeriod = AcademicPeriod.getLatest()

    # Now parsing the CSV and populating database tables `CourseInstance` and `CourseEvent`
    log.info("Reading courses from CSV '%s' for current academic period %s..." % [
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
        CourseInstance.new(
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
        ).save!()
      end
      { # :Hash<DayOfWeek, Array<Time, Time> | nil>
        DayOfWeek::MONDAY => parsedRow.lunes,
        DayOfWeek::TUESDAY => parsedRow.martes,
        DayOfWeek::WEDNESDAY => parsedRow.miércoles,
        DayOfWeek::THURSDAY => parsedRow.jueves,
        DayOfWeek::FRIDAY => parsedRow.viernes
      }.each do |dayOfWeek, eventTimes|
        if (eventTimes != nil)
          eventType = csvEventTypesHash[parsedRow.tipoEvento]
          raise RuntimeError.new(
            "CSV parsing error at line %d: invalid event type value '%s', must be one of %s" % [
              rowIndex + 2, parsedRow.tipoEvento, csvEventTypesHash.values()
            ]
          ) unless (eventType != nil)
          CourseEvent.new(
            location: parsedRow.sala,
            day_of_week: DayOfWeek.parseStringDay(dayOfWeek),
            start_time: eventTimes.first(),
            end_time: eventTimes.second(),
            date: parsedRow.fechaInicio,
            course_instance: CourseInstance.find_by(nrc: parsedRow.nrc),
            # course_instance: CourseInstance.last(), #? or should bind by ID/NRC?
            event_type: eventType
          ).save!()
        end
      end
    end

    log.info("CSV parsing complete, loaded %d CourseInstances and %d CourseEvents" % [
      CourseInstance.count(), CourseEvent.count()
    ])
  end
end
