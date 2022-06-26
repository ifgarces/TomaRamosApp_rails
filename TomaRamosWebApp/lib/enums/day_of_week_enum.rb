# Enum-like module for modeling a day of the week (as Ruby does not have a build-in one, unlike
# Java/Kotlin)

module DayOfWeekEnum
  public

  MONDAY = "LUNES"
  TUESDAY = "MARTES"
  WEDNESDAY = "MIÉRCOLES"
  THURSDAY = "JUEVES"
  FRIDAY = "VIERNES"
  SATURDAY = "SÁBADO"
  SUNDAY = "DOMINGO"

  # @param cleanDay [String]
  # @return [Boolean]
  def self.isDayStringValid(cleanDay)
    return ([
      DayOfWeekEnum::MONDAY,
      DayOfWeekEnum::TUESDAY,
      DayOfWeekEnum::WEDNESDAY,
      DayOfWeekEnum::THURSDAY,
      DayOfWeekEnum::FRIDAY,
      DayOfWeekEnum::SATURDAY,
      DayOfWeekEnum::SUNDAY
    ].include?(cleanDay))
  end

  # @param dayString [String]
  # @return [DayOfWeekEnum]
  def self.parseStringDay(dayString)
    day = dayString.upcase().strip()
    raise ArgumentError.new(
      "Provided value '%s' is not a valid DayOfWeekEnum, must be one of %s" % [dayString, validValues]
    ) unless (self.isDayStringValid(day))
    return day
  end
end
