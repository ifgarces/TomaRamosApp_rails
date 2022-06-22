# Inscribe-able course instance.
#
# @!attribute nrc
#   @return [String] Unique number for a course instance for a given `AcademicPeriod`. Not the
#   primary key at a database level, as we will have multiple periods.
#
# @!attribute title
#   @return [String] Course name or title.
#
# @!attribute teacher
#   @return [String] Assigned teacher(s) names for this course instance.
#
# @!attribute credits
#   @return [Integer] 'Indicador de carga académica'
#
# @!attribute career
#   @return [String] Reference for the career (specifically, the engineering specialty) related to
#   the course (e.g. "ICC", "ICI").
#
# @!attribute course_number
#   @return [Integer] Reference for the parent course this instance belongs to (not that we are
#   missing that model as it is internal information of the faculty).
#
# @!attribute section
#   @return [String] Instance number (kind of index relative to the CourseInstance, for each "course")
#
# @!attribute curriculum
#   @return [String] Reference to the 'plan de estudios' version the course belongs to, e.g. "2022",
#   "2016".
#
# @!attribute liga
#   @return [String] 'Connector liga' (no idea what this is...) #?
#
# @!attribute lcruz
#   @return [String] 'Lista cruzada' (no idea what this is...) #?

class CourseInstance < ApplicationRecord
  has_many :course_events, :dependent => :destroy
  belongs_to :academic_period
  has_and_belongs_to_many :user_course_inscriptions

  validates :nrc, numericality: true
end
