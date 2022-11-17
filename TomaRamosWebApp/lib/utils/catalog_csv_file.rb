# Simple class for mapping CSV file names and amount of header rows.
class CatalogCsvFile
  attr_reader :name, :headerRows

  def initialize(name:, headerRows:)
    @name = name
    @headerRows = headerRows
  end
end
