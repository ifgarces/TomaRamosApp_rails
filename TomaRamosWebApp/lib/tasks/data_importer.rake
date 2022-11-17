require "utils/logging_util"
require "utils/catalog_csv_file"
require "csv_parsing/csv_data_importer"

@log = LoggingUtil.getStdoutLogger(__FILE__)

#CSV_FILE_PATH = "db/catalog-ing.csv"
CSV_ROOT_PATH = "db/catalog"

ING_FILE_NAMES = [
  CatalogCsvFile.new(name: "base.csv", headerRows: 12), # own courses from the curriculum of the career
  CatalogCsvFile.new(name: "electives.csv", headerRows: 0) # PEGs, electives, etc.
]

# @param [String] periodName
# @return [nil] Wether the CSV files are properly located for the given period name.
def isCsvPathOk(periodName)
  return Dir.exist?(
    File.join(CSV_ROOT_PATH, periodName)
  ) && Dir.exist?(
    File.join(CSV_ROOT_PATH, File.join(periodName, "ing"))
  )
end

# Deletes all `CourseEvents` of `CourseInstance`s belonging to a given `AcademicPeriod`.
# @param [AcademicPeriod] academicPeriod
# @return [nil]
def clearCourseEvents(academicPeriod)
  academicPeriod.getCourseEvents().each do |event|
    event.destroy!()
  end
end

namespace :data_importer do
  task :csv, [:period] => :environment do |_, args|
    desc "
    Imports course data from a CSV sheet file, in the format provided from the faculty, at Canvas,
    for a given `AcademicPeriod`.
    
    Args:
      period [String | nil] Name of the target academic period. The latest period will be used if
      absent or nil.
    "

    # Reading academic period
    if (args[:period].nil?)
      targetPeriod = AcademicPeriod.getLatest()
      raise Exception.new(
        "Fatal: could not get latest academic period"
      ) unless (targetPeriod != nil)
    else
      targetPeriod = AcademicPeriod.find_by(name: args[:period].strip())
      raise ArgumentError.new(
        "Academic period named '%s' not found" % [args[:period]]
      ) unless (targetPeriod != nil)
    end

    if (!isCsvPathOk(targetPeriod.name))
      raise Exception.new(
        "Missing directory '%s/%s/%s'" % [CSV_ROOT_PATH, targetPeriod.name, "ing"]
      )
    end

    @log.info("Clearing CourseEvents of period '%s' prior to CSV parsing..." % [targetPeriod.name])
    clearCourseEvents(targetPeriod)

    ING_FILE_NAMES.each do |csvFile|
      filePath = File.join(
        CSV_ROOT_PATH, File.join(targetPeriod.name, File.join("ing", csvFile.name))
      )
      @log.info("Importing file '%s'" % [filePath])
      prevEventsCount = CourseEvent.count()

      courses, eventsMapping = CsvDataImporter.import(
        csvPath: filePath,
        csvHeaderSize: csvFile.headerRows,
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
      @log.info("Successfully imported %d courses from '%s'" % [
        CourseEvent.count() - prevEventsCount, filePath
      ])
    end

    @log.info("[OK] CSV parsing complete for period '%s': loaded %d CourseInstances and %d CourseEvents" % [
      targetPeriod.name, targetPeriod.getCourses().count(), targetPeriod.getCourseEvents().count()
    ])
  end
end
