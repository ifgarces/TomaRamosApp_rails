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

  # @param day [String]
  # @return [DayOfWeekEnum]
  def self.parseStringDay(day)
    validValues = [
      DayOfWeekEnum::MONDAY,
      DayOfWeekEnum::TUESDAY,
      DayOfWeekEnum::WEDNESDAY,
      DayOfWeekEnum::THURSDAY,
      DayOfWeekEnum::FRIDAY,
      DayOfWeekEnum::SATURDAY,
      DayOfWeekEnum::SUNDAY
    ]

    raise ArgumentError.new(
      "Provided value '#%s' is not a valid DayOfWeekEnum, must be one of %s" % [
        day, validValues
      ]
    ) unless validValues.include?(day)
    return day
  end
end
