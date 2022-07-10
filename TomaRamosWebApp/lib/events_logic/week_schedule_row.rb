require "utils/logging_util"
require "enums/day_of_week_enum"

class WeekScheduleRow
  attr_reader :monday, :tuesday, :wednesday, :thursday, :friday

  def initialize()
    @log = LoggingUtil.getStdoutLogger(__FILE__)

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

  # @param courseEvent [CourseEvent]
  # @return [nil]
  def addEvent(courseEvent)
    raise TypeError.new(
      "Argument '%s' is of type %s, not CourseEvent" % [courseEvent, courseEvent.class]
    ) unless (courseEvent.is_a?(CourseEvent))

    # Skipping evaluation events
    if (courseEvent.event_type.isEvaluation())
      return
    end

    @dayMappings[courseEvent.day_of_week].append(courseEvent)
  end

  # @return [Boolean]
  def ==(obj)
    if (obj.nil?) || (!obj.is_a?(WeekScheduleRow))
      return false
    end
    return (
      self.monday == obj.monday &&
      self.tuesday == obj.tuesday &&
      self.wednesday == obj.wednesday &&
      self.thursday == obj.thursday &&
      self.friday == obj.friday
      #self.to_json() == obj.to_json()
    )
  end

  # @return [String]
  def to_s()
    return "WeekScheduleRow(monday: %s, tuesday: %s, wednesday: %s, thursday: %s, friday: %s)" % [
      @monday, @tuesday, @wednesday, @thursday, @friday
    ]
  end
end
