require "enums/event_type_enum"
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

  # @param event1 [CourseEvent]
  # @param event2 [CourseEvent]
  # @return [Boolean]
  def self.areEventsInConflict(event1, event2)
    #TODO
    raise NotImplementedError.new()
  end

  # @return [String] Short description
  def toReadableStringShort()
    #TODO
    raise NotImplementedError.new()
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
