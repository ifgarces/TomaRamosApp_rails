class AcademicPeriod < ApplicationRecord
  has_many :course_instances

  public

  @@LATEST_PERIOD_NAME = "2022-10"

  # @return [Array<CourseInstance>] the collection of `CourseInstance`s belonging to the academic
  # period.
  def getRamos()
    return CourseInstance.where(academic_period: self.id)
  end

  def self.getLatestPeriodName()
    return @@LATEST_PERIOD_NAME
  end

  # @return [AcademicPeriod | nil]
  def self.getLatest()
    return AcademicPeriod.find_by(name: @@LATEST_PERIOD_NAME)
    # return AcademicPeriod.all().order(created_at: :asc).last()
  end
end
