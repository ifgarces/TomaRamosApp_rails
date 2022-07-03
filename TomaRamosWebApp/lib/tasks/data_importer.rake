require "logger"
require "utils/csv_data_importer"

@log = LoggingUtil.newStdoutLogger(__FILE__)

CSV_FILE_PATH = "db/catalog-ing.csv"

namespace :data_importer do

  task csv: :environment do
    desc "
    Imports course data from a CSV sheet file, in the format provided from the faculty, at Canvas,
    for a given `AcademicPeriod`.
    "

    targetPeriod = AcademicPeriod.getLatest()

    CsvDataImporter.import(CSV_FILE_PATH, targetPeriod)
  end
end
