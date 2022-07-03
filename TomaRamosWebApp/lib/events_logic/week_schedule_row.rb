require "enums/day_of_week_enum"

class WeekScheduleRow
  attr_reader :monday, :tuesday, :wednesday, :thursday, :friday

  def initialize()
    @monday = []
    @tuesday = []
    @wednesday = []
    @thursday = []
    @friday = []
    @saturday = []
    @sunday = []

    @dayMappings = {
      DayOfWeekEnum::MONDAY => @monday,
      DayOfWeekEnum::TUESDAY => @tuesday,
      DayOfWeekEnum::WEDNESDAY => @wednesday,
      DayOfWeekEnum::THURSDAY => @thursday,
      DayOfWeekEnum::FRIDAY => @friday,
      DayOfWeekEnum::SATURDAY => @saturday,
      DayOfWeekEnum::SUNDAY => @sunday
    }
  end

  # @param dayOfWeek [String] One of `DayOfWeekEnum`.
  # @param courseEvent [CourseEvent]
  # @return [nil]
  def addEvent(dayOfWeek:, courseEvent:)
    raise TypeError.new(
      "Argument '%s' is of type %s, not CourseEvent" % [courseEvent, courseEvent.class]
    ) unless (courseEvent.is_a?(CourseEvent))

    @dayMappings[dayOfWeek].append(courseEvent)
  end

  # @return [String]
  def to_s()
    return "WeekScheduleRow(monday: %s, tuesday: %s, wednesday: %s, thursday: %s, friday: %s)" % [
      @monday, @tuesday, @wednesday, @thursday, @friday
    ]
  end
end
