require "test_helper"
require "csv"
require "csv_parsing/csv_row"
require "enums/event_type_enum"

class CsvRowTest < ActiveSupport::TestCase
  # @param expectedRow [Object]
  # @param gotRow [Object]
  # @return [nil]
  def assertEqualCsvRows(expectedRow, gotRow)
    #? could this be optimized to make it less ugly, with something similar to Python's `getattr`?
    assertEqualOrNil(expectedRow.pe, gotRow.pe)
    assert_equal(expectedRow.nrc, gotRow.nrc)
    assertEqualOrNil(expectedRow.conectorLiga, gotRow.conectorLiga)
    assertEqualOrNil(expectedRow.listaCruzada, gotRow.listaCruzada)
    assert_equal(expectedRow.materia, gotRow.materia)
    assert_equal(expectedRow.curso, gotRow.curso)
    assert_equal(expectedRow.sección, gotRow.sección)
    assert_equal(expectedRow.nombre, gotRow.nombre)
    assertEqualOrNil(expectedRow.créditos, gotRow.créditos)
    assertEqualTimeInterval(expectedRow.lunes, gotRow.lunes)
    assertEqualTimeInterval(expectedRow.martes, gotRow.martes)
    assertEqualTimeInterval(expectedRow.miércoles, gotRow.miércoles)
    assertEqualTimeInterval(expectedRow.jueves, gotRow.jueves)
    assertEqualTimeInterval(expectedRow.viernes, gotRow.viernes)
    assertEqualOrNil(expectedRow.fechaInicio, gotRow.fechaInicio)
    assertEqualOrNil(expectedRow.fechaFin, gotRow.fechaFin)
    assertEqualOrNil(expectedRow.sala, gotRow.sala)
    assert_equal(expectedRow.tipoEvento, gotRow.tipoEvento)
    assert_equal(expectedRow.profesor, gotRow.profesor)
  end

  test "CsvRow success 01" do
    testRawRow = "202110,PE2016,4444,,,ING,1100,1,ALGEBRA E INTR. AL CALCULO,10,,,,,14:30 -16:20,,7/3/2022,22/06/2022,,AYUD,tata Sánchez la leyenda"

    expectedRow = OpenStruct.new(
      pe: "PE2016",
      nrc: 4444,
      conectorLiga: nil,
      listaCruzada: nil,
      materia: "ING",
      curso: 1100,
      sección: "1",
      nombre: "ALGEBRA E INTR. AL CALCULO",
      créditos: "10",
      lunes: nil,
      martes: nil,
      miércoles: nil,
      jueves: nil,
      viernes: [Time.utc(2000, 1, 1, 14, 30), Time.utc(2000, 1, 1, 16, 20)],
      fechaInicio: Date.new(2022, 3, 7),
      fechaFin: Date.new(2022, 6, 22),
      sala: nil,
      tipoEvento: EventTypeEnum::ASSISTANTSHIP,
      profesor: "tata Sánchez la leyenda"
    )
    gotRow = CsvRow.new(
      CSV.parse(testRawRow, col_sep: ",").first()
    )
    self.assertEqualCsvRows(expectedRow, gotRow)
  end

  test "CsvRow success 02" do
    testRawRow = "202110,PE2016,3972,BA,,ICC,4103,BB,WEB TECHNOLOGIES,6,13:30 -15:20,,,,,,07/03/2022,22/06/2022,R-27,CLAS,ALVAREZ/GOMEZ CLAUDIO JAVIER"

    expectedRow = OpenStruct.new(
      pe: "PE2016",
      nrc: 3972,
      conectorLiga: "BA",
      listaCruzada: nil,
      materia: "ICC",
      curso: 4103,
      sección: "BB",
      nombre: "WEB TECHNOLOGIES",
      créditos: "6",
      lunes: [Time.utc(2000, 1, 1, 13, 30), Time.utc(2000, 1, 1, 15, 20)],
      martes: nil,
      miércoles: nil,
      jueves: nil,
      viernes: nil,
      fechaInicio: Date.new(2022, 3, 7),
      fechaFin: Date.new(2022, 6, 22),
      sala: "R-27",
      tipoEvento: EventTypeEnum::CLASS,
      profesor: "ALVAREZ/GOMEZ CLAUDIO JAVIER"
    )
    gotRow = CsvRow.new(
      CSV.parse(testRawRow, col_sep: ",").first()
    )
    self.assertEqualCsvRows(expectedRow, gotRow)
  end

  test "CsvRow success 03" do
    testRawRow = "202110,PE2016,3972,BA,qwerty,ICC,4103,99,WEB TECHNOLOGIES,6,,,,19:30 -  22:00,,,07/03/2022,22/06/2022,R-27,AYUD,ALVAREZ/GOMEZ CLAUDIO JAVIER"

    expectedRow = OpenStruct.new(
      pe: "PE2016",
      nrc: 3972,
      conectorLiga: "BA",
      listaCruzada: "qwerty",
      materia: "ICC",
      curso: 4103,
      sección: "99",
      nombre: "WEB TECHNOLOGIES",
      créditos: "6",
      lunes: nil,
      martes: nil,
      miércoles: nil,
      jueves: [Time.utc(2000, 1, 1, 19, 30), Time.utc(2000, 1, 1, 22, 0)],
      viernes: nil,
      fechaInicio: Date.new(2022, 3, 7),
      fechaFin: Date.new(2022, 6, 22),
      sala: "R-27",
      tipoEvento: EventTypeEnum::ASSISTANTSHIP,
      profesor: "ALVAREZ/GOMEZ CLAUDIO JAVIER"
    )
    gotRow = CsvRow.new(
      CSV.parse(testRawRow, col_sep: ",").first()
    )
    self.assertEqualCsvRows(expectedRow, gotRow)
  end

  test "CsvRow success 04" do
    testRawRow = "202110,PE2016,3972,,,ICC,4103,BB,WEB TECHNOLOGIES,1,,08:30-09:20,,,,,07/03/2040,22/06/2040,qwerty,LABT,ALVAREZ/GOMEZ CLAUDIO JAVIER"

    expectedRow = OpenStruct.new(
      pe: "PE2016",
      nrc: 3972,
      conectorLiga: nil,
      listaCruzada: nil,
      materia: "ICC",
      curso: 4103,
      sección: "BB",
      nombre: "WEB TECHNOLOGIES",
      créditos: "1",
      lunes: nil,
      martes: [Time.utc(2000, 1, 1, 8, 30), Time.utc(2000, 1, 1, 9, 20)],
      miércoles: nil,
      jueves: nil,
      viernes: nil,
      fechaInicio: Date.new(2040, 3, 7),
      fechaFin: Date.new(2040, 6, 22),
      sala: "qwerty",
      tipoEvento: EventTypeEnum::LABORATORY,
      profesor: "ALVAREZ/GOMEZ CLAUDIO JAVIER"
    )
    gotRow = CsvRow.new(
      CSV.parse(testRawRow, col_sep: ",").first()
    )
    self.assertEqualCsvRows(expectedRow, gotRow)
  end

  test "CsvRow failure blank title" do
    testRawRow = "202110,PE2016,    3972  ,BA,qwerty,ICC,4103,99,,6,,,19:30 -  22:00,,,07/03/2022,22/06/2022,R-27,AYUD,ALVAREZ/GOMEZ CLAUDIO JAVIER  "
    gotError = assert_raise(Exception) do
      CsvRow.new(
        CSV.parse(testRawRow, col_sep: ",").first()
      )
    end
    assert_equal(RuntimeError, gotError.class)
    assert(gotError.message.starts_with?("One of the mandatory fields is nil for CsvRow"))
  end
end
