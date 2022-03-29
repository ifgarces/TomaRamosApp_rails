# Unlike Java/Kotlin, Ruby doesn't have a built-in library for days of week
module DayOfWeek
    MONDAY = 0
    TUESDAY = 1
    WEDNESDAY = 2
    THURSDAY = 3
    FRIDAY = 4
    SATURDAY = 5
    SUNDAY = 6

    def dayToString(day_enum)
        case day_enum
        when DayOfWeek::MONDAY
            return "monday"
        when DayOfWeek::TUESDAY
            return "tuesday"
        when DayOfWeek::WEDNESDAY
            return "wednesday"
        when DayOfWeek::THURSDAY
            return "thursday"
        when DayOfWeek::FRIDAY
            return "friday"
        when DayOfWeek::SATURDAY
            return "saturday"
        when DayOfWeek::SUNDAY
            return "sunday"
        else
            raise "[DayOfWeek::dayToString] Invalid day_enum passed"
        end
    end

    def parseStringDay(dayString)
        case dayString
        when "monday"
            return DayOfWeek::MONDAY
        when "tuesday"
            return DayOfWeek::TUESDAY
        when "wednesday"
            return DayOfWeek::WEDNESDAY
        when "thursday"
            return DayOfWeek::THURSDAY
        when "friday"
            return DayOfWeek::FRIDAY
        when "saturday"
            return DayOfWeek::SATURDAY
        when "sunday"
            return DayOfWeek::SUNDAY
        end
    end

end
