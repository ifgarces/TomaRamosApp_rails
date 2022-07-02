require "utils/string_util"

# An event from a `CourseInstance` event, such as a class or evaluation, belonging to a
# `CourseInstance`. Evaluations are not "recurrent", as non-evaluation events are "recurrent",
# weekly. The `date` for these weekly events is not relevant and therefore is `nil`.
#
# @!attribute location
#   @return [String | nil] 'Sala'. Can be non-set (`nil`) for online courses.
#
# @!attribute day_of_week
#   @return [String] 'Día de la semana'
#
# @!attribute start_time
#   @return [Time] 'Inicio'
#
# @!attribute end_time
#   @return [Time] 'Término'
#
# @!attribute date
#   @return [Date | nil] 'Fecha'

class CourseEvent < ApplicationRecord
  belongs_to :course_instance
  belongs_to :event_type

  # Compares events in search for conflicts. For evaluations, date and time are considered, while
  # for non-evaluation events, their day_of_week and time intervals are checked.
  # @param left [CourseEvent]
  # @param right [CourseEvent]
  # @return [Boolean] Whether `left` starts before `right` finished and `left` finishes after
  # `right` starts
  def self.areEventsInConflict(left, right)
    isEvalLeft = left.event_type.isEvaluation()
    isEvalRight = right.event_type.isEvaluation()

    if (isEvalLeft && isEvalRight)
      if ((left.date == nil) || (right.date == nil))
        raise ArgumentError.new(
          "Cannot check conflicts between evaluations if one of them has no date: left=%s, right=%s" % [
            left, right
          ]
        )
      end
      if (left.date != right.date)
        return false
      end
    elsif ((!isEvalLeft) && (!isEvalRight))
      if (left.day_of_week != right.day_of_week)
        return false
      end
    else
      raise ArgumentError.new(
        "Cannot check conflicts between an evaluation and a non-evaluation: left=%s, right=%s" % [
          left, right
        ]
      )
    end

    return (
      (left.start_time <= right.end_time) && (left.end_time >= right.start_time)
    )
  end

  # @return [String]
  def toReadableStringShort()
    return "CourseEvent(event_type: %s, location: %s, day_of_week: %s, date: %s, start_time: %s, end_time: %s)" % [
      self.event_type, self.location, self.day_of_week, self.date, self.start_time, self.end_time
    ]
  end

  # @return [String] Long description
  def toReadableStringLong()
    dateOrDayString = self.event_type.isEvaluation() \
      ? self.date.to_s() : self.day_of_week
    locationString = (
      (self.location == nil) || (self.location == "")
    ) ? "(no informada)": self.location
    recurrentEventStart = (
      (!self.event_type.isEvaluation()) && (self.date != nil)
    ) ? "Inicia desde: #{self.date}" : ""
    return %{
Tipo: #{self.event_type.name}
Ramo: #{self.course_instance.title} (NRC #{self.course_instance.nrc})
Fecha: #{dateOrDayString} (#{StringUtil.getReadableTimeInterval(self.start_time, self.end_time)})
Sala: #{locationString}
#{recurrentEventStart}
}.strip()
  end
end
