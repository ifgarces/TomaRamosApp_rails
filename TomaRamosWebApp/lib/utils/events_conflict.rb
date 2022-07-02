require "utils/string_util"

# Represents a mapping between two events that are conflicted with each other.
class EventsConflict
  attr_reader :leftEvent, :rightEvent

  # @param leftEvent [CourseEvent]
  # @param rightEvent [CourseEvent]
  def initialize(leftEvent, rightEvent)
    @leftEvent = leftEvent
    @rightEvent = rightEvent

    raise ArgumentError.new(
      "One of the provided arguments is not a CourseEvents: #{self}"
    ) unless (@leftEvent.is_a?(CourseEvent) && @rightEvent.is_a?(CourseEvent))
  end

  # @return [String]
  def to_s()
    return StringUtil.unindent("
      EventsConflict(
        leftEvent: %s,
        rightEvent: %s
      )
    ") % [@leftEvent.toReadableStringShort(), @rightEvent.toReadableStringShort()]
  end

  def ==(obj)
    if ((obj.nil?) || (!obj.is_a?(EventsConflict)))
      return false
    end
    return (
      self.leftEvent == obj.leftEvent &&
      self.rightEvent == obj.rightEvent
    )
  end
end
