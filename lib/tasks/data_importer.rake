namespace :data_importer do
    desc "
    Rake task(s) for importing data from sheet files (e.g. CSV) for when the faculty performs changes
    on the catalog.
    "

    #require "dotenv/tasks" # ensuring the `.env` file is loaded, ref: https://forum.upcase.com/t/accessing-env-variables-in-rake-task/1381/2
    require "time"
    require "date"
    require "logger"
    require "csv"

    # Retraives data from the CSV (standard engineering faculty format) and fills the database
    task csv_all: :environment do
        log = Rails.logger

        CsvColumns = OpenStruct.new(
            :plan_estudios => 0,
            :nrc           => 1,
            :conector_liga => 2,
            :lista_cruzada => 3,
            :materia       => 4,
            :cursonum      => 5,
            :seccion       => 6,
            :nombre        => 7,
            :credito       => 8,
            :lunes         => 9,
            :martes        => 10,
            :miercoles     => 11,
            :jueves        => 12,
            :viernes       => 13,
            :fecha_inicio  => 15,
            :fecha_fin     => 16,
            :sala          => 17,
            :tipo_evento   => 18,
            :profesor      => 19
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
            def initialize(row_cells)
                @pe = row_cells[CsvColumns.plan_estudios] # string | nil
                @nrc = row_cells[CsvColumns.nrc].to_i() # integer
                @conector_liga = row_cells[CsvColumns.conector_liga] # string | nil
                @lista_cruzada = row_cells[CsvColumns.lista_cruzada] # string | nil
                @materia = row_cells[CsvColumns.materia] # string | nil
                @curso = row_cells[CsvColumns.cursonum].to_i()
                @seccion = row_cells[CsvColumns.seccion] # string | nil
                @nombre = row_cells[CsvColumns.nombre] # string | nil
                @credito = row_cells[CsvColumns.credito] # string | nil
                @lunes = CsvRow.parseTimeInterval(row_cells[CsvColumns.lunes]) # List[Time] | nil
                @martes = CsvRow.parseTimeInterval(row_cells[CsvColumns.martes]) # List[Time] | nil
                @miercoles = CsvRow.parseTimeInterval(row_cells[CsvColumns.miercoles]) # List[Time] | nil
                @jueves = CsvRow.parseTimeInterval(row_cells[CsvColumns.jueves]) # List[Time] | nil
                @viernes = CsvRow.parseTimeInterval(row_cells[CsvColumns.viernes]) # List[Time] | nil
                @fecha_inicio = CsvRow.parseDate(row_cells[CsvColumns.fecha_inicio]) # Date | nil
                @fecha_fin = CsvRow.parseDate(row_cells[CsvColumns.fecha_fin]) # Date | nil
                @sala = row_cells[CsvColumns.sala] # string | nil
                @tipo_evento = row_cells[CsvColumns.tipo_evento].tr("0-9", "") # string, ignoring numbers (e.g. "PRBA 1" is treated as just "PRBA")
                @profesor = row_cells[CsvColumns.profesor] # string | nil

                # Ensuring mandatory fields are not null
                [@pe, @nrc, @materia, @seccion, @nombre, @tipo_evento, @profesor].each { |field|
                    raise "One of the mandatory fields is nil for CsvRow %s" % [self] \
                        unless (field != nil)
                }
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
        Ramo.delete_all()
        RamoEvent.delete_all()

        # Now parsing the CSV and populating database tables `ramo` and `ramo_event`
        csv_rows = CSV.read(Figaro.env.CSV_FILE_PATH) # :List[List[string]]
        csv_rows.delete_at(0) # ignoring headers
        csv_rows = csv_rows.map { |row|
            row.map { |item|
                item == nil ? nil : item.strip()
            }
        }
        csv_rows.each { |row|
            log.debug("Processing %s" % [row])
            CsvRow.new(row)
        }

        throw NotImplementedError
    end

end
