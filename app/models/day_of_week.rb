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
        def self.parseStringDay(dayString)
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
