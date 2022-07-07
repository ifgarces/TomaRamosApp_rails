# Represents a course inscription period.
#
# @!attribute name
#   @return [string] Period common name (e.g. "2021-20", or maybe "202120", haven't decided yet)

class AcademicPeriod < ApplicationRecord
  has_many :course_instances

  private

  @@LATEST_PERIOD_NAME = "2022-10"

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

  def self.getLatestPeriodName()
    return @@LATEST_PERIOD_NAME
  end

  # @return [AcademicPeriod | nil]
  def self.getLatest()
    return AcademicPeriod.find_by(name: @@LATEST_PERIOD_NAME)
  end
end
