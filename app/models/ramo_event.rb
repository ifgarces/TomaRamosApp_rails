class RamoEvent < ApplicationRecord
    belongs_to :ramo
    belongs_to :ramo_event_type

public
    # Checks whether the event is an evaluation (test or exam) or not (class, laboratory, assistanship).
    # @return [Boolean]
    def is_evaluation()
        return (self.ramo_event_type.name == "PRBA") || (self.ramo_event_type.name == "EXAM")
    end

    # @return [String] multiline description of the event.
    def get_description_long()
        dateOrDayString = self.is_evaluation() ? self.date.to_s() : DayOfWeek.toStringSpanish(self.day_of_week)
        locationString = (self.location == "") ? "(no informada)" : self.location
        return %{
Tipo: #{self.ramo_event_type.toStringLarge()}
Ramo: #{self.ramo.nombre} (NRC #{self.ramo.nrc})
Fecha: #{dateOrDayString} (#{self.start_time} - #{self.end_time})
Sala: #{locationString}
#{
    if ((! self.is_evaluation()) && (self.date != nil))
        "Inicia desde: %s" % [self.date]
    else
        ""
    end
}
}.strip()
    end

    # @return [String]
    def get_description_short()
        #TODO, if needed at all in this web version
        raise NotImplementedError
    end
end
