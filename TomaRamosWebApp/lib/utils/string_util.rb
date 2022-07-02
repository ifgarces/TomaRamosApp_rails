require "time"
require "enums/event_type_enum"

module StringUtil
  # @param startTime [Time]
  # @param endTime [Time]
  # @return [String]
  def self.getReadableTimeInterval(startTime, endTime)
    return "%s:%s – %s:%s" % [startTime.hour, startTime.min, endTime.hour, endTime.min]
  end

  # Removes extra blank spaces from a string, intended for multiline string literals.
  # References: https://stackoverflow.com/a/33530265/12684271
  # @param string [String]
  # @return [String]
  def self.unindent(string)
    return string.strip().gsub(/^#{string.scan(/^[ \t]+(?=\S)/).min}/, '')
  end

  # For getting an explicit career name for a `CourseInstance`'s `career` attribute.
  # @param career [String]
  # @return [String] Or `nil` in case the value is invalid or not recognized
  def self.getReadableCareer(career)
    careerMappings = {
      "ING" => "Ing. Civil Plan Común",
      "ICC" => "Ing. Civil Computación",
      "ICI" => "Ing. Civil Industrial",
      "IOC" => "Ing. Civil Obras",
      "ICE" => "Ing. Civil Eléctrica",
      "ICA" => "Ing. Civil Ambiental"
    }
    return careerMappings.keys().include?(career) ? careerMappings[career] : nil
  end

  # Returns the larger description of the event (by its `name`).
  # @param eventTypeStr [String]
  # @return [String]
  def self.getReadableEventType(eventTypeStr)
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
