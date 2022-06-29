require "logger"
require "utils/csv_data_importer"

@log = LoggingUtil.getStdoutLogger(__FILE__)

CSV_FILE_PATH = "db/catalog-ing.csv"

namespace :data_importer do

  task csv: :environment do
    desc "
    Imports course data from sheet files (e.g. CSV) for when the faculty performs changes on the
    catalog for the latest `AcademicPeriod`.
    "

    CsvDataImporter.import(CSV_FILE_PATH)
  end
end
