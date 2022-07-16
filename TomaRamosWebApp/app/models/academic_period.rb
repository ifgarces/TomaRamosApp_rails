# Represents a course inscription period.
#
# @!attribute name
#   @return [string] Period common name (e.g. "2021-20", or maybe "202120", haven't decided yet)

class AcademicPeriod < ApplicationRecord
  has_many :course_instances

  private

  @@LATEST_PERIOD_NAME = "2022-20"

  public

  # @return [Array<CourseInstance>]
  def getCourses()
    return self.course_instances.order(title: :asc, section: :asc)
  end

  # @return [Array<CourseEvent>]
  def getCourseEvents()
    return CourseEvent.all().order(course_instance_id: :asc).filter { |event|
      event.course_instance.academic_period == self
    }
  end

  # @return [String]
  def self.getLatestPeriodName()
    return @@LATEST_PERIOD_NAME
  end

  # @return [AcademicPeriod | nil]
  def self.getLatest()
    return AcademicPeriod.find_by(name: @@LATEST_PERIOD_NAME)
  end

  # Computes the latest date in which a course belonging to this period was updated for the last
  # time.
  # References: https://stackoverflow.com/a/53840477/12684271
  #
  # @return [Date] With timezone at Santiago/CL, not UTC
  def getLastUpdatedDate()
    eventsLastUpdateTimestamp = self.getCourseEvents().map { |course|
      course.updated_at
    }.sort_by { |timestamp|
      timestamp
    }.last()

    coursesLastUpdateTimestamp = self.getCourses().map { |course|
      course.updated_at
    }.sort_by { |timestamp|
      timestamp
    }.last()

    latestChange = [
      eventsLastUpdateTimestamp, coursesLastUpdateTimestamp
    ].sort().last()

    return latestChange.in_time_zone("America/Santiago").to_date()
  end
end
