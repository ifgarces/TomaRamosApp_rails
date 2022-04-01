# Unlike Java/Kotlin, Ruby doesn't have a built-in library for days of week
module DayOfWeek
    MONDAY = "monday"
    TUESDAY = "tuesday"
    WEDNESDAY = "wednesday"
    THURSDAY = "thursday"
    FRIDAY = "friday"
    SATURDAY = "saturday"
    SUNDAY = "sunday"

public
    # @param dayString [String]
    # @return [DayOfWeek]
    def self.parseStringDay(dayString)
        return case dayString
            when "monday"
                DayOfWeek::MONDAY
            when "tuesday"
                DayOfWeek::TUESDAY
            when "wednesday"
                DayOfWeek::WEDNESDAY
            when "thursday"
                DayOfWeek::THURSDAY
            when "friday"
                DayOfWeek::FRIDAY
            when "saturday"
                DayOfWeek::SATURDAY
            when "sunday"
                DayOfWeek::SUNDAY
            end
    end

    # @param sayOfWeek [DayOfWeek]
    # @return [String]
    def self.toStringSpanish(dayOfWeek)
        return case dayOfWeek
            when DayOfWeek::MONDAY
                "Lunes"
            when DayOfWeek::TUESDAY
                "Martes"
            when DayOfWeek::WEDNESDAY
                "Miércoles"
            when DayOfWeek::THURSDAY
                "Jueves"
            when DayOfWeek::FRIDAY
                "Viernes"
            when DayOfWeek::SATURDAY
                "Sábado"
            when DayOfWeek::SUNDAY
                "Domingo"
            end
    end
end
