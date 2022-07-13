require "enums/event_type_enum"
require "events_logic/conflict"

# Inscribe-able course instance.
#
# @!attribute nrc
#   @return [String] Unique number for a course instance for a given `AcademicPeriod`. Not the
#   primary key at a database level, as we will have multiple periods. It is stored as a String
#   instead of an Integer directly because CSV format is sometimes messy or incomplete (so we could
#   have a "PENDING" value for an NRC when and if needed at a given point).
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
  has_and_belongs_to_many :inscriptions

  validates :nrc, numericality: true

  # @param academicPeriod [AcademicPeriod]
  # @param searchText [String] Or `nil` if no search was performed.
  # @return [Array<CourseInstance>] Partially or fully matching `CourseInstance`s by their `nrc` or
  # `title`.
  def self.search(academicPeriod, searchText)
    courses = academicPeriod.getCourses()
    if (searchText == nil)
      return courses
    end
    #searchText.downcase!()
    searchText = searchText.parameterize(separator: " ")
    return courses.filter { |course|
      course.title.downcase().include?(searchText) || course.nrc.include?(searchText)
    }
  end

  # @param leftCourse [CourseInstance]
  # @param rightCourse [CourseInstance]
  # @return [Array<EventConflict>] Whether the given courses have events that collide with each
  # other
  def self.getConflictsBetween(leftCourse, rightCourse)
    raise ArgumentError.new(
      "Cannot compare equal courses: #{leftCourse}"
    ) unless (leftCourse.id != rightCourse.id)

    conflicts = []

    leftEvents = leftCourse.course_events
    rightEvents = rightCourse.course_events

    leftEvents.each do |left|
      rightEvents.each do |right|
        if (left.event_type.isEvaluation() == right.event_type.isEvaluation())
          if (CourseEvent.areEventsInConflict(left, right))
            conflicts.append(
              Conflict.new(left, right)
            )
          end
        end
      end
    end

    return conflicts
  end

  # @return [Array<CourseEvent>]
  def getEventsClasses()
    classType = EventType.find_by(name: EventTypeEnum::CLASS)
    return self.course_events.where(event_type: classType)
  end

  # @return [Array<CourseEvent>]
  def getEventsAssistantshipsAndLabs()
    assistType = EventType.find_by(name: EventTypeEnum::ASSISTANTSHIP)
    labType = EventType.find_by(name: EventTypeEnum::LABORATORY)
    return self.course_events.where(event_type: [assistType, labType])
  end

  # @return [Array<CourseEvent>]
  def getEventsEvaluations()
    testType = EventType.find_by(name: EventTypeEnum::TEST)
    examType = EventType.find_by(name: EventTypeEnum::EXAM)
    return self.course_events.where(event_type: [testType, examType]).order(date: :asc)
  end
end
