#! ---
#! DEPRECATED
#! ---

require "time"
require "date"
require "csv"
require "utils/day_of_week"

log = Rails.logger

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
      :cursonum => 5,
      :seccion => 6,
      :nombre => 7,
      :credito => 8,
      :lunes => 9,
      :martes => 10,
      :miercoles => 11,
      :jueves => 12,
      :viernes => 13,
      :fechaInicio => 15,
      :fechaFin => 16,
      :sala => 17,
      :tipoEvento => 18,
      :profesor => 19
    )

    # Mapping CSV cell values for actual indexed event type in database
    CsvEventTypesMapping = {
      "CLAS" => RamoEventType.find_by(name: "CLAS"),
      "AYUD" => RamoEventType.find_by(name: "AYUD"),
      "LABT" => RamoEventType.find_by(name: "LABT"),
      "TUTR" => RamoEventType.find_by(name: "LABT"),
      "PRBA" => RamoEventType.find_by(name: "PRBA"),
      "EXAM" => RamoEventType.find_by(name: "EXAM")
    }

    # Helper class for parsing rows from the CSV
    class CsvRow
      attr_reader :pe, :nrc, :conectorLiga, :listaCruzada, :materia, :curso, :seccion, :nombre,
                  :credito, :lunes, :martes, :miercoles, :jueves, :viernes, :fechaInicio,
                  :fechaFin, :sala, :tipoEvento, :profesor

      def initialize(row_cells)
        @pe = row_cells[CsvColumns.plan_estudios] # string | nil
        @nrc = row_cells[CsvColumns.nrc].to_i() # integer
        @conectorLiga = row_cells[CsvColumns.conectorLiga] # string | nil
        @listaCruzada = row_cells[CsvColumns.listaCruzada] # string | nil
        @materia = row_cells[CsvColumns.materia] # string | nil
        @curso = row_cells[CsvColumns.cursonum].to_i() # integer
        @seccion = row_cells[CsvColumns.seccion] # string | nil
        @nombre = row_cells[CsvColumns.nombre] # string | nil
        @credito = row_cells[CsvColumns.credito] # string | nil
        @lunes = CsvRow.parseTimeInterval(row_cells[CsvColumns.lunes]) # List[Time] | nil
        @martes = CsvRow.parseTimeInterval(row_cells[CsvColumns.martes]) # List[Time] | nil
        @miercoles = CsvRow.parseTimeInterval(row_cells[CsvColumns.miercoles]) # List[Time] | nil
        @jueves = CsvRow.parseTimeInterval(row_cells[CsvColumns.jueves]) # List[Time] | nil
        @viernes = CsvRow.parseTimeInterval(row_cells[CsvColumns.viernes]) # List[Time] | nil
        @fechaInicio = CsvRow.parseDate(row_cells[CsvColumns.fechaInicio]) # Date | nil
        @fechaFin = CsvRow.parseDate(row_cells[CsvColumns.fechaFin]) # Date | nil
        @sala = row_cells[CsvColumns.sala] # string | nil
        @tipoEvento = row_cells[CsvColumns.tipoEvento].tr("0-9", "").strip() # string, ignoring numbers (e.g. "PRBA 1" is treated as just "PRBA")
        @profesor = row_cells[CsvColumns.profesor] # string | nil

        # Ensuring mandatory fields are not null
        [@pe, @nrc, @materia, @seccion, @nombre, @tipoEvento, @profesor].each do |field|
          raise "One of the mandatory fields is nil for CsvRow %s" % [self] unless (field != nil)
        end
      end

      # Returns a pair of `Time` object
      def self.parseTimeInterval(cellValue)
        if (cellValue == nil)
          return nil
        end
        buff = cellValue.split(Figaro.env.CSV_TIME_SEPARATOR)
        return [
                 Time.parse(buff[0].strip()),
                 Time.parse(buff[1].strip())
               ]
      end

      def self.parseDate(cellValue)
        if (cellValue == nil)
          return nil
        end
        return DateTime.parse(cellValue).to_date() #TODO ensure this works
      end

      def to_s()
        return self.as_json.to_s
      end
    end

    log.info("Clearing Ramo and RamoEvent tables prior to CSV parsing")
    #TODO: only delete data for the current target academic period, not all!
    RamoEvent.delete_all()
    Ramo.delete_all()

    currentAcademicPeriod = CatalogStatus.get_academic_period()
    log.info("Reading CSV for academic period %s..." % [currentAcademicPeriod.name])

    # Now parsing the CSV and populating database tables `ramo` and `ramo_event`
    csvRows = CSV.read(Figaro.env.CSV_FILE_PATH) # :List[List[string]]
    csvRows.delete_at(0) # ignoring headers
    csvRows = csvRows.map { |row|
      row.map { |item|
        (item == nil) ? nil : item.strip()
      }
    }
    ramosNrcs = [] # :List[str]
    csvRows.each_with_index do |row, row_index|
      log.trace("Processing row %s" % [row])
      parsedRow = CsvRow.new(row)
      if (!ramosNrcs.include?(parsedRow.nrc))
        ramosNrcs.append(parsedRow.nrc)
        Ramo.new(
          nrc: parsedRow.nrc,
          nombre: parsedRow.nombre,
          profesor: parsedRow.profesor,
          creditos: parsedRow.credito,
          materia: parsedRow.materia,
          curso: parsedRow.curso,
          seccion: parsedRow.seccion,
          plan_estudios: parsedRow.pe,
          conect_liga: parsedRow.conectorLiga,
          lista_cruzada: parsedRow.listaCruzada,
          academic_period: currentAcademicPeriod
        ).save!()
      end
      { # :Hash[DayOfWeek, Pair[Time, Time] | nil|]
        DayOfWeek::MONDAY => parsedRow.lunes,
        DayOfWeek::TUESDAY => parsedRow.martes,
        DayOfWeek::WEDNESDAY => parsedRow.miercoles,
        DayOfWeek::THURSDAY => parsedRow.jueves,
        DayOfWeek::FRIDAY => parsedRow.viernes
      }.each do |dayOfWeek, eventTimes|
        if (eventTimes != nil)
          eventType = CsvEventTypesMapping[parsedRow.tipoEvento]
          raise "CSV parsing error at line %d: invalid event type value '%s', must be one of %s" % [
                  row_index + 2, parsedRow.tipoEvento, CsvEventTypesMapping.values()
                ] unless (eventType != nil)
          RamoEvent.new(
            location: parsedRow.sala,
            day_of_week: DayOfWeek.parseStringDay(dayOfWeek),
            start_time: eventTimes.first(),
            end_time: eventTimes.second(),
            date: parsedRow.fechaInicio,
            ramo: Ramo.last(), #? or should bind by ID/NRC?
            ramo_event_type: eventType
          ).save!()
        end
      end
    end

    log.info(
      "CSV parsing complete. Loaded %d Ramos and %d RamoEvents" % [
        Ramo.count(), RamoEvent.count()
      ]
    )
  end
end
