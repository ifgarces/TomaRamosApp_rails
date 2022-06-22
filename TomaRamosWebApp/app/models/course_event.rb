# An event from a `CourseInstance` event, such as a class or evaluation, belonging to a
# `CourseInstance`. Evaluations are not "recurrent", as non-evaluation events are "recurrent",
# weekly. The `date` for these weekly events is not relevant and therefore is `nil`.
#
# @!attribute location
#   @return [String] 'Sala'
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

  public

  # Checks whether the event is an evaluation (test or exam) or not (class, laboratory,
  # assistantship).
  # @return [Boolean]
  def isEvaluation()
    raise NotImplementedError.new("DEPRECATED METHOD NEEDING UPDATE!") #!

    return (self.ramo_event_type.name == "PRBA") || (self.ramo_event_type.name == "EXAM")
  end

  # @return [String]
  def getDescriptionShort()
    raise NotImplementedError.new("DEPRECATED METHOD NEEDING UPDATE!") #!

    #TODO, if needed at all in this web version
    raise NotImplementedError
  end

  # @return [String] multiline description of the event.
  def getDescriptionLong()
    raise NotImplementedError.new("DEPRECATED METHOD NEEDING UPDATE!") #!
    dateOrDayString = self.is_evaluation() ? self.date.to_s() : DayOfWeek.toStringSpanish(self.day_of_week)
    locationString = (self.location == "") ? "(no informada)" : self.location
    recurrentEventInfo = if ((!self.is_evaluation()) && (self.date != nil))
        "Inicia desde: %s" % [self.date]
      else
        ""
      end
    return %{
Tipo: #{self.ramo_event_type.to_string_large()}
Ramo: #{self.ramo.nombre} (NRC #{self.ramo.nrc})
Fecha: #{dateOrDayString} (#{self.start_time} - #{self.end_time})
Sala: #{locationString}
#{recurrentEventInfo}
}.strip()
  end
end
