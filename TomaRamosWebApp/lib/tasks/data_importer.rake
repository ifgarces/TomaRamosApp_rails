require "logger"
require "csv_parsing/csv_data_importer"

@log = LoggingUtil.getStdoutLogger(__FILE__)

CSV_FILE_PATH = "db/catalog-ing.csv"
CSV_HEADER_ROWS_COUNT = 12

namespace :data_importer do
  task csv: :environment do
    desc "
    Imports course data from a CSV sheet file, in the format provided from the faculty, at Canvas,
    for a given `AcademicPeriod`.
    "

    targetPeriod = AcademicPeriod.getLatest()

    @log.info("Clearing CourseEvent table prior to CSV parsing...")
    targetPeriod.getCourseEvents().each do |event|
      event.destroy!()
    end

    courses, eventsMapping = CsvDataImporter.import(
      csvPath: CSV_FILE_PATH,
      csvHeaderSize: CSV_HEADER_ROWS_COUNT,
      academicPeriod: targetPeriod
    )

    courses.each do |courseInstance|
      courseInstance.save!()
    end

    eventsMapping.each do |nrc, events|
      events.each do |courseEvent|
        courseEvent.course_instance = CourseInstance.find_by(nrc: nrc)
        courseEvent.save!()
      end
    end

    @log.info("✔️ CSV parsing complete: loaded %d CourseInstances and %d CourseEvents" % [
      targetPeriod.getCourses().count(), targetPeriod.getCourseEvents().count()
    ])
  end
end
