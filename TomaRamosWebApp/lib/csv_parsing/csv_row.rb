require "time"
require "date"

# Helper class for parsing rows from the CSV
class CsvRow
  private

  CSV_TIME_SEPARATOR = "-"

  # Mapping each column of the CSV file
  ColumnsMappings = OpenStruct.new(
    planEstudios: 1,
    nrc: 2,
    conectorLiga: 3,
    listaCruzada: 4,
    materia: 5,
    númeroCurso: 6,
    sección: 7,
    nombre: 8,
    créditos: 9,
    lunes: 10,
    martes: 11,
    miércoles: 12,
    jueves: 13,
    viernes: 14,
    fechaInicio: 16,
    fechaFin: 17,
    sala: 18,
    tipoEvento: 19,
    profesor: 20
  )

  public

  attr_reader :pe, :nrc, :conectorLiga, :listaCruzada, :materia, :curso, :sección, :nombre,
              :créditos, :lunes, :martes, :miércoles, :jueves, :viernes, :fechaInicio, :fechaFin,
              :sala, :tipoEvento, :profesor

  # @param rowCells [Array<String>]
  def initialize(rowCells)
    @pe = rowCells[ColumnsMappings.planEstudios] # String
    @nrc = rowCells[ColumnsMappings.nrc].to_i() # Integer
    @conectorLiga = rowCells[ColumnsMappings.conectorLiga] # String | nil
    @listaCruzada = rowCells[ColumnsMappings.listaCruzada] # String | nil
    @materia = rowCells[ColumnsMappings.materia] # String
    @curso = rowCells[ColumnsMappings.númeroCurso].to_i() # Integer
    @sección = rowCells[ColumnsMappings.sección] # String
    @nombre = rowCells[ColumnsMappings.nombre] # String
    @créditos = rowCells[ColumnsMappings.créditos] # String | nil
    @lunes = CsvRow.parseTimeInterval(rowCells[ColumnsMappings.lunes]) # Array<Time, Time> | nil
    @martes = CsvRow.parseTimeInterval(rowCells[ColumnsMappings.martes])
    @miércoles = CsvRow.parseTimeInterval(rowCells[ColumnsMappings.miércoles])
    @jueves = CsvRow.parseTimeInterval(rowCells[ColumnsMappings.jueves])
    @viernes = CsvRow.parseTimeInterval(rowCells[ColumnsMappings.viernes])
    @fechaInicio = CsvRow.parseDate(rowCells[ColumnsMappings.fechaInicio]) # Date | nil
    @fechaFin = CsvRow.parseDate(rowCells[ColumnsMappings.fechaFin]) # Date | nil
    @sala = rowCells[ColumnsMappings.sala] # String | nil
    @tipoEvento = rowCells[ColumnsMappings.tipoEvento].tr("0-9", "").strip() # String, ignoring digits (e.g. "PRBA 1" => "PRBA")
    @profesor = rowCells[ColumnsMappings.profesor] # String

    # Ensuring mandatory fields are not null
    [@pe, @nrc, @materia, @sección, @nombre, @tipoEvento, @profesor].each do |field|
      raise RuntimeError.new(
        "One of the mandatory fields is nil for CsvRow: #{self.to_json()}"
      ) unless (field != nil)
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
end
