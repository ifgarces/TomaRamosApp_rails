module EventTypeEnum
  public

  CLASS = "CLAS"
  ASSISTANTSHIP = "AYUD"
  LABORATORY = "LABT"
  TEST = "PRBA"
  EXAM = "EXAM"

  # @param eventTypeStr [String]
  # @return [Boolean]
  def self.validate(eventTypeStr)
    return [
      EventTypeEnum::CLASS,
      EventTypeEnum::ASSISTANTSHIP,
      EventTypeEnum::LABORATORY,
      EventTypeEnum::TEST,
      EventTypeEnum::EXAM
    ].include?(eventTypeStr)
  end

  # Returns the larger description of the event (by its `name`).
  # @param eventTypeStr [String]
  # @return [String]
  def self.toReadableString(eventTypeStr)
    return case (eventTypeStr)
      when EventTypeEnum::CLASS
        "Clase"
      when EventTypeEnum::ASSISTANTSHIP
        "Ayudantía"
      when EventTypeEnum::LABORATORY
        "Laboratorio"
      when EventTypeEnum::TEST
        "Prueba"
      when EventTypeEnum::EXAM
        "Examen"
      else
        raise ArgumentError.new(
          "Unknown EventType name '%s', can't convert to large string" % [self.name]
        )
      end
  end
end
